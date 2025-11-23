-- Store player row labels
GUI.GamePlayersListRows = GUI.GamePlayersListRows or {}

-- Create background container if it doesn't exist
if not GUI.PlayersListContainer then
    GUI.PlayersListContainer = Geyser.Label:new({
        name = "GUI.PlayersListContainer",
        x = 0, y = 0,
        width = "100%", height = "100%"
    }, GUI.PlayersScrollBox)
    GUI.PlayersListContainer:setStyleSheet([[background-color: rgba(0,0,0,255);]])
end

-- Hover event handlers
function GamePlayersRowHoverEnter(index)
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(40,40,40,255);
        ]])
    end
end

function GamePlayersRowHoverLeave(index)
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:setStyleSheet([[
            qproperty-wordWrap: true;
            background-color: rgba(0,0,0,255);
        ]])
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

-- Get image path based on guild and gender
local function getGuildImagePath(guild, gender)
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
    local content = string.format(
        "<table width=\"100%%\"><tr><td width=\"20%%\" valign=\"center\" align=\"center\"><font size=\"8\"><img src=\"%s\"></font></td>" ..
        "<td width=\"80%%\" valign=\"center\" align=\"left\"><font size=\"4\">%s</font>",
        getGuildImagePath(player.guild, player.gender), firstToUpper(player.name)
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
    
    if GUI.GamePlayersListRows[index] then
        GUI.GamePlayersListRows[index]:resize("100%", rowHeight .. "px")
        GUI.GamePlayersListRows[index]:move(0, yPos .. "px")
        GUI.GamePlayersListRows[index]:echo(generatePlayerRowContent(player))
        GUI.GamePlayersListRows[index]:echo(content)
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