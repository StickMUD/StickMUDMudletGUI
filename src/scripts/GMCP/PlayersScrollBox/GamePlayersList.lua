-- Store player row labels
GUI.GamePlayersListRows = GUI.GamePlayersListRows or {}

-- Store row Y positions for popup alignment
GUI.GamePlayersListRowYPos = GUI.GamePlayersListRowYPos or {}

-- Track selected player row and popup
GUI.SelectedPlayerRowIndex = nil
GUI.PlayerDetailPopup = nil

-- Create background container if it doesn't exist
if not GUI.PlayersListContainer then
    GUI.PlayersListContainer = Geyser.Label:new({
        name = "GUI.PlayersListContainer",
        x = 0, y = 0,
        width = "100%", height = "100%"
    }, GUI.PlayersScrollBox)
    GUI.PlayersListContainer:setStyleSheet([[background-color: rgba(0,0,0,255);]])
    -- Click on container background closes the popup
    GUI.PlayersListContainer:setClickCallback("ClosePlayerDetailPopup")
end

-- Close the player detail popup
function ClosePlayerDetailPopup()
    -- Unregister global click handler
    if GUI.PlayerPopupClickHandler then
        killAnonymousEventHandler(GUI.PlayerPopupClickHandler)
        GUI.PlayerPopupClickHandler = nil
    end
    
    -- Clean up labels (hide them)
    if GUI.PlayerDetailPopupLabels then
        for _, label in ipairs(GUI.PlayerDetailPopupLabels) do
            if label then
                label:hide()
            end
        end
        GUI.PlayerDetailPopupLabels = nil
    end
    
    if GUI.PlayerDetailPopup then
        GUI.PlayerDetailPopup:hide()
        GUI.PlayerDetailPopup = nil
    end
    -- Reset previously selected row
    if GUI.SelectedPlayerRowIndex and GUI.GamePlayersListRows[GUI.SelectedPlayerRowIndex] then
        GUI.GamePlayersListRows[GUI.SelectedPlayerRowIndex]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(0,0,0,255);
        ]])
    end
    GUI.SelectedPlayerRowIndex = nil
end

-- Check if a click is inside the popup bounds
function IsClickInsidePopup(x, y)
    if not GUI.PlayerDetailPopup then return false end
    
    local popupX = GUI.PlayerDetailPopup:get_x()
    local popupY = GUI.PlayerDetailPopup:get_y()
    local popupWidth = GUI.PlayerDetailPopup:get_width()
    local popupHeight = GUI.PlayerDetailPopup:get_height()
    
    return x >= popupX and x <= popupX + popupWidth and
           y >= popupY and y <= popupY + popupHeight
end

-- Check if a click is inside the selected player row
function IsClickInsideSelectedRow(x, y)
    if not GUI.SelectedPlayerRowIndex or not GUI.GamePlayersListRows[GUI.SelectedPlayerRowIndex] then
        return false
    end
    
    local row = GUI.GamePlayersListRows[GUI.SelectedPlayerRowIndex]
    local rowX = row:get_x()
    local rowY = row:get_y()
    local rowWidth = row:get_width()
    local rowHeight = row:get_height()
    
    return x >= rowX and x <= rowX + rowWidth and
           y >= rowY and y <= rowY + rowHeight
end

-- Global click handler to close popup when clicking outside
function HandleGlobalClickForPopup(event, x, y)
    -- Small delay to allow the click to be processed by the popup first
    tempTimer(0.05, function()
        if GUI.PlayerDetailPopup then
            -- Close if click is outside both popup and selected row
            if not IsClickInsidePopup(x, y) and not IsClickInsideSelectedRow(x, y) then
                ClosePlayerDetailPopup()
            end
        end
    end)
end

-- Show player detail popup
function ShowPlayerDetailPopup(index, player)
    -- Close any existing popup first
    ClosePlayerDetailPopup()
    
    -- Mark this row as selected
    GUI.SelectedPlayerRowIndex = index
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(60,60,60,255);
        ]])
    end
    
    -- Store player data for the popup
    GUI.SelectedPlayerData = player
    
    -- Request detailed player info via GMCP
    sendGMCP("Game.Players.Info {\"name\": \"" .. player.name .. "\"}")
    
    -- Create the popup container to the LEFT of PlayersScrollBox
    -- Position it in GUI.Right so it can extend beyond the PlayersScrollBox bounds
    local popupWidth = 300
    local popupHeight = 150
    
    -- Calculate position relative to GUI.Right
    local rightX = GUI.Right:get_x()
    local rightY = GUI.Right:get_y()
    local rightWidth = GUI.Right:get_width()
    local menuBoxX = GUI.MenuBox:get_x()
    local menuBoxY = GUI.MenuBox:get_y()
    
    -- Position popup to the left of MenuBox, relative to GUI.Right
    local popupX = (menuBoxX - rightX) - popupWidth - 10  -- 10px gap from MenuBox edge
    
    -- Ensure popup doesn't extend past the left edge of GUI.Right
    -- If it would, reduce popup width to fit
    if popupX < 5 then
        local availableWidth = (menuBoxX - rightX) - 15  -- 5px left margin + 10px gap from MenuBox
        if availableWidth < 150 then
            -- Not enough room on left, position at bottom of GUI.Right instead
            popupX = 10
            popupWidth = rightWidth - 20
        else
            popupWidth = availableWidth
            popupX = 5
        end
    end
    
    -- Get the row's stored Y position (we store this when creating/updating rows)
    local rowYWithinContainer = GUI.GamePlayersListRowYPos and GUI.GamePlayersListRowYPos[index] or 0
    
    -- Calculate popup Y relative to GUI.Right
    -- MenuBox Y relative to Right + row Y within the scroll container
    local popupY = (menuBoxY - rightY) + rowYWithinContainer
    
    -- Check if popup would extend beyond MenuBox bottom
    local menuBoxBottom = (menuBoxY - rightY) + GUI.MenuBox:get_height()
    local popupBottom = popupY + popupHeight
    
    if popupBottom > menuBoxBottom then
        -- Adjust so popup bottom aligns with MenuBox bottom
        popupY = menuBoxBottom - popupHeight
    end
    
    GUI.PlayerDetailPopup = Geyser.Label:new({
        name = "GUI.PlayerDetailPopup",
        x = popupX,
        y = popupY,
        width = popupWidth,
        height = popupHeight
    }, GUI.Right)
    
    -- Store the actual popup width for use by GamePlayersInfo.lua
    GUI.PlayerDetailPopupWidth = popupWidth
    
    GUI.PlayerDetailPopup:setStyleSheet([[
        background-color: rgba(30,30,35,255);
        border: 2px solid rgba(80,80,90,255);
        border-radius: 8px;
    ]])
    
    -- Height calculation constants (same as GamePlayersInfo.lua)
    local avatarHeight = 68      -- Avatar row (64px image + small padding)
    local nameLineHeight = 22    -- Name (font size 4)
    local infoLineHeight = 16    -- Info lines (font size 3)
    local padding = 6            -- Top/bottom padding
    
    -- Build initial rows with available data
    local rows = {}
    
    -- Avatar row
    table.insert(rows, {
        height = avatarHeight,
        content = string.format(
            [[<center><img src="%s" width="64" height="64"></center>]],
            getGuildImagePath(player.guild, player.gender)
        )
    })
    
    -- Name row
    table.insert(rows, {
        height = nameLineHeight,
        content = string.format(
            [[<center><font size="4" color="white"><b>%s</b></font></center>]],
            firstToUpper(player.name)
        )
    })
    
    -- Race/Guild row
    table.insert(rows, {
        height = infoLineHeight,
        content = string.format(
            [[<center><font size="3" color="silver">%s %s</font></center>]],
            firstToUpper(player.race),
            firstToUpper(player.guild)
        )
    })
    
    -- Level row
    table.insert(rows, {
        height = infoLineHeight,
        content = string.format(
            [[<center><font size="3" color="gray">Level %d</font></center>]],
            player.level
        )
    })
    
    -- Calculate total height
    local totalHeight = padding
    for _, row in ipairs(rows) do
        totalHeight = totalHeight + row.height
    end
    totalHeight = totalHeight + padding
    
    -- Resize popup to fit initial content
    GUI.PlayerDetailPopup:resize(nil, totalHeight)
    
    -- Store row labels for potential future reference
    GUI.PlayerDetailPopupLabels = {}
    
    -- Create individual labels for each row with absolute positioning
    local currentY = padding
    for i, row in ipairs(rows) do
        local labelName = "GUI.PlayerDetailPopupRow" .. i
        local label = Geyser.Label:new({
            name = labelName,
            x = 0,
            y = currentY .. "px",
            width = "100%",
            height = row.height .. "px",
        }, GUI.PlayerDetailPopup)
        
        label:setStyleSheet([[
            background-color: transparent;
            qproperty-wordWrap: true;
        ]])
        
        label:echo(row.content)
        
        -- TODO: Uncomment when Mudlet 4.20+ is released
        -- Apply link style if specified
        -- if row.linkStyle then
        --     label:setLinkStyle(row.linkStyle[1], row.linkStyle[2], row.linkStyle[3])
        -- end
        
        -- Prevent clicks from closing the popup
        label:setClickCallback(function() end)
        
        label:show()
        label:raise()
        
        GUI.PlayerDetailPopupLabels[i] = label
        currentY = currentY + row.height
    end
    
    -- Set an empty click callback to prevent clicks from propagating to parent
    GUI.PlayerDetailPopup:setClickCallback(function() end)
    
    GUI.PlayerDetailPopup:show()
    GUI.PlayerDetailPopup:raise()
    
    -- Register global click handler to close popup when clicking anywhere outside
    if GUI.PlayerPopupClickHandler then
        killAnonymousEventHandler(GUI.PlayerPopupClickHandler)
    end
    GUI.PlayerPopupClickHandler = registerAnonymousEventHandler(
        "sysWindowMousePressEvent",
        "HandleGlobalClickForPopup"
    )
end

-- Hover event handlers
function GamePlayersRowHoverEnter(index)
    -- Don't change hover style if this row is selected
    if GUI.SelectedPlayerRowIndex == index then return end
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(40,40,40,255);
        ]])
    end
end

function GamePlayersRowHoverLeave(index)
    -- Don't change hover style if this row is selected
    if GUI.SelectedPlayerRowIndex == index then return end
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(0,0,0,255);
        ]])
    end
end

-- Click handler for player rows
function GamePlayersRowClick(index, player)
    -- If clicking the same row, close the popup
    if GUI.SelectedPlayerRowIndex == index then
        ClosePlayerDetailPopup()
    else
        ShowPlayerDetailPopup(index, player)
    end
end

-- Check if a value is a number
local function isNumber(value) return type(value) == 'number' end

-- Filter functions
local function filterByCoder(player) return isNumber(player.coder) and player.coder ~= 0 end
local function filterByPlayer(player) return not filterByCoder(player) end

-- Format large numbers
local function readableNumber(num, places)
    if not num then return "0" end
    local placeValue = ("%%.%df"):format(places or 0)
    if num >= 1e12 then return placeValue:format(num / 1e12) .. "T"
    elseif num >= 1e9 then return placeValue:format(num / 1e9) .. "B"
    elseif num >= 1e6 then return placeValue:format(num / 1e6) .. "M"
    elseif num >= 1e3 then return placeValue:format(num / 1e3) .. "k"
    else return tostring(num) end
end

-- Get image path based on guild and gender (global for popup access)
function getGuildImagePath(guild, gender)
    local basePath = getMudletHomeDir() .. "/StickMUD/"
    local images = {
        bard = gender == "female" and "066-musician.png" or "056-bard.png",
        fighter = gender == "female" and "070-girl.png" or "057-knight-2.png",
        healer = gender == "female" and "069-hippie-1.png" or "067-hippie.png",
        mage = gender == "female" and "068-magician.png" or "065-wizard.png",
        necromancer = gender == "female" and "071-skeleton.png" or "059-necromancer.png",
        ninja = gender == "female" and "062-ninja-1.png" or "058-ninja.png",
        priest = gender == "female" and "061-cross.png" or "060-priest.png",
        thief = gender == "female" and "063-people.png" or "064-man.png",
        default = "029-dazed.png"
    }
    return basePath .. (images[guild] or images.default)
end

-- Generate player row HTML content
local function generatePlayerRowContent(player)
    -- Build AFK indicator for avatar area
    local afkIndicator = ""
    if player.afk ~= nil then
        if player.afk == 0 then
            -- Active - sun emoji on dark blue circle
            afkIndicator = [[<span style="background-color: #1a237e; border: 1px solid #0d1440; border-radius: 5px; font-size: 12px;">☀️</span>]]
        elseif player.afk == 1 then
            -- Away - moon on dark blue circle
            afkIndicator = [[<span style="background-color: #1a237e; border: 1px solid #0d1440; border-radius: 5px; font-size: 12px;">🌙</span>]]
        end
    end
    
    -- Build OPK tag for after name (not clickable here - click row to see popup with clickable OPK)
    local opkTag = ""
    if player.opt_in_pk == 1 then
        opkTag = [[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color: #cc0000; color: white; padding: 0px 4px; font-weight: bold; border-radius: 2px; font-size: 10px; vertical-align: middle; line-height: 14px;">OPK</span>]]
    end
    
    -- Build avatar cell with AFK indicator in lower-right corner using nested table
    local avatarCell
    if afkIndicator ~= "" then
        avatarCell = string.format(
            [[<td width="20%%" valign="center" align="center"><table cellspacing="0" cellpadding="0"><tr><td rowspan="2" align="center"><img src="%s"></td><td width="1">&nbsp;</td></tr><tr><td valign="bottom" align="right">%s</td></tr></table></td>]],
            getGuildImagePath(player.guild, player.gender),
            afkIndicator
        )
    else
        avatarCell = string.format(
            [[<td width="20%%" valign="center" align="center"><font size="8"><img src="%s"></font></td>]],
            getGuildImagePath(player.guild, player.gender)
        )
    end
    
    local content = string.format(
        [[<table width="100%%"><tr>%s<td width="80%%" valign="center" align="left"><font size="4">%s</font>%s]],
        avatarCell, firstToUpper(player.name), opkTag
    )
    content = content .. string.format(
        "<br><font size=\"3\" color=\"silver\">%s %s - Level %d</font>",
        firstToUpper(player.race), player.guild, player.level
    )
    if player.exprate_hour > 0 then
        content = content .. string.format(
            "<br><font size=\"3\" color=\"orange\"><i>%s/h exp</i></font>",
            readableNumber(player.exprate_hour)
        )
    end
    return content .. "</td></tr></table>"
end

-- Create or update a player row label
local function createPlayerRow(index, yPos, player)
    local rowName = "GUI.GamePlayersRow_" .. index
    local rowHeight = player.exprate_hour > 0 and 55 or 43
    
    -- Store the Y position for popup alignment
    GUI.GamePlayersListRowYPos[index] = yPos
    
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:resize("100%", rowHeight .. "px")
        GUI.GamePlayersListRows[index]:move(0, yPos .. "px")
        GUI.GamePlayersListRows[index]:echo(generatePlayerRowContent(player))
        GUI.GamePlayersListRows[index]:show()
        -- Update click callback with current player data
        GUI.GamePlayersListRows[index]:setClickCallback("GamePlayersRowClick", index, player)
    else
        GUI.GamePlayersListRows[index] = Geyser.Label:new({
            name = rowName,
            x = 0, y = yPos .. "px",
            width = "100%", height = rowHeight .. "px"
        }, GUI.PlayersListContainer)
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(0,0,0,255);
        ]])
        GUI.GamePlayersListRows[index]:echo(generatePlayerRowContent(player))
        
        -- Add hover effect
        GUI.GamePlayersListRows[index]:setOnEnter("GamePlayersRowHoverEnter", index)
        GUI.GamePlayersListRows[index]:setOnLeave("GamePlayersRowHoverLeave", index)
        
        -- Add click handler
        GUI.GamePlayersListRows[index]:setClickCallback("GamePlayersRowClick", index, player)
    end
    
    return rowHeight
end

-- Create or update a section header label
local function createSectionHeader(index, yPos, title)
    local rowName = "GUI.GamePlayersRow_" .. index
    local rowHeight = 25
    local content = string.format("<font size=\"3\" color=\"gray\">%s</font>", title)
    
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:resize("100%", rowHeight .. "px")
        GUI.GamePlayersListRows[index]:move(0, yPos .. "px")
        GUI.GamePlayersListRows[index]:echo(content)
        GUI.GamePlayersListRows[index]:show()
    else
        GUI.GamePlayersListRows[index] = Geyser.Label:new({
            name = rowName,
            x = 0, y = yPos .. "px",
            width = "100%", height = rowHeight .. "px"
        }, GUI.PlayersListContainer)
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(0,0,0,255);
        ]])
        GUI.GamePlayersListRows[index]:echo(content)
    end
    
    return rowHeight
end

-- Create the Game Players List using individual labels
function GamePlayersList()
    -- Close any existing popup to ensure clean state on reconnect
    ClosePlayerDetailPopup()
    
    local game_players_list = gmcp.Game and gmcp.Game.Players and gmcp.Game.Players.List or {}
    local yPos = 0
    local rowIndex = 1

    -- Immortals Section
    local coders = table.n_filter(game_players_list, filterByCoder)
    if #coders > 0 then
        table.sort(coders, function(a, b) return a.coder > b.coder end)
        yPos = yPos + createSectionHeader(rowIndex, yPos, string.format("IMMORTALS - %d", #coders))
        rowIndex = rowIndex + 1
        
        for _, player in ipairs(coders) do
            yPos = yPos + createPlayerRow(rowIndex, yPos, player)
            rowIndex = rowIndex + 1
        end
    end

    -- Players Section
    local players = table.n_filter(game_players_list, filterByPlayer)
    if #players > 0 then
        table.sort(players, function(a, b) return a.level > b.level end)
        yPos = yPos + createSectionHeader(rowIndex, yPos, string.format("PLAYERS - %d", #players))
        rowIndex = rowIndex + 1
        
        for _, player in ipairs(players) do
            yPos = yPos + createPlayerRow(rowIndex, yPos, player)
            rowIndex = rowIndex + 1
        end
    end
    
    -- Hide any unused row labels from previous renders
    for i = rowIndex, #GUI.GamePlayersListRows do
        if GUI.GamePlayersListRows[i] then
            GUI.GamePlayersListRows[i]:hide()
        end
    end
end

on_menu_box_press("PlayersScrollBox")