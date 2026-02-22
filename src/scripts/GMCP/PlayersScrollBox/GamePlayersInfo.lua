-- Handle Game.Players.Info GMCP response
-- Updates the player detail popup with additional information

-- Default popup width (may be overridden by GUI.PlayerDetailPopupWidth from GamePlayersList.lua)
local DEFAULT_POPUP_WIDTH = 300

-- Helper to get actual popup width
local function getPopupWidth()
    return GUI.PlayerDetailPopupWidth or DEFAULT_POPUP_WIDTH
end

function GamePlayersInfo()
    local info = gmcp.Game and gmcp.Game.Players and gmcp.Game.Players.Info or {}
    
    -- Check if we have a popup open and the info is for the selected player
    if not GUI.PlayerDetailPopup or not GUI.SelectedPlayerData then
        return
    end
    
    -- Check if this info is for the currently selected player
    if not info.name or info.name:lower() ~= GUI.SelectedPlayerData.name:lower() then
        return
    end
    
    -- Update stored player data with new info
    for k, v in pairs(info) do
        GUI.SelectedPlayerData[k] = v
    end
    
    -- Height calculation constants
    local avatarHeight = 68      -- Avatar row (64px image + small padding)
    local nameLineHeight = 22    -- Name (font size 4)
    local infoLineHeight = 16    -- Info lines (font size 3)
    local smallLineHeight = 14   -- Small lines (font size 2)
    local padding = 6            -- Top/bottom padding
    
    -- Build list of content rows to determine height
    local rows = {}
    
    -- Avatar row
    table.insert(rows, {
        height = avatarHeight,
        content = string.format(
            [[<center><img src="%s" width="64" height="64"></center>]],
            getGuildImagePath(info.guild, info.gender)
        )
    })
    
    -- Name row
    table.insert(rows, {
        height = nameLineHeight,
        content = string.format(
            [[<center><font size="4" color="white"><b>%s</b></font></center>]],
            firstToUpper(info.name)
        )
    })
    
    -- Race/Guild/Level row
    table.insert(rows, {
        height = infoLineHeight,
        content = string.format(
            [[<center><font size="3" color="silver">%s %s - Level %d</font></center>]],
            firstToUpper(info.race),
            firstToUpper(info.guild),
            info.level
        )
    })
    
    -- Alignment row
    if info.alignment then
        table.insert(rows, {
            height = infoLineHeight,
            content = string.format(
                [[<center><font size="3" color="gray">%s</font></center>]],
                firstToUpper(info.alignment)
            )
        })
    end
    
    -- Age row
    if info.age then
        table.insert(rows, {
            height = infoLineHeight,
            content = string.format(
                [[<center><font size="3" color="gray">Age: %s</font></center>]],
                info.age
            )
        })
    end
    
    -- Clan row (clickable link)
    if info.clan_name then
        local clanDisplay = info.clan_name
        if info.clan_leader == 1 then
            clanDisplay = clanDisplay .. " (leader)"
        end
        table.insert(rows, {
            height = infoLineHeight,
            content = string.format(
                [[<center><a href="send:clan members %s"><font size="3" color="cyan">%s</font></a></center>]],
                info.clan,
                clanDisplay
            ),
            linkStyle = {"cyan", "cyan", false}
        })
    end
    
    -- Noble title row
    if info.noble_title then
        local kingdomText = ""
        if info.kingdom then
            if type(info.kingdom) == "table" then
                -- Multiple kingdoms - create links for each
                local kingdomLinks = {}
                for _, k in ipairs(info.kingdom) do
                    table.insert(kingdomLinks, string.format(
                        [[<a href="send:kingdoms %s">%s</a>]],
                        k, firstToUpper(k)
                    ))
                end
                kingdomText = " of " .. table.concat(kingdomLinks, ", ")
            else
                kingdomText = string.format(
                    [[ of <a href="send:kingdoms %s">%s</a>]],
                    info.kingdom, firstToUpper(info.kingdom)
                )
            end
        end
        table.insert(rows, {
            height = infoLineHeight,
            content = string.format(
                [[<center><font size="3" color="gold">%s%s</font></center>]],
                info.noble_title,
                kingdomText
            ),
            linkStyle = {"gold", "gold", false}
        })
    end
    
    -- Deity row
    if info.deity then
        table.insert(rows, {
            height = infoLineHeight,
            content = string.format(
                [[<center><font size="3" color="magenta">Follower of %s</font></center>]],
                info.deity
            )
        })
    end
    
    -- Top rankings rows (one per skill)
    if info.top_rankings and next(info.top_rankings) then
        for skill, rank in pairs(info.top_rankings) do
            local rankColor = rank == 1 and "gold" or "silver"
            table.insert(rows, {
                height = smallLineHeight,
                content = string.format(
                    [[<center><a href="send:best %s"><font size="2" color="%s">#%d %s</font></a></center>]],
                    skill, rankColor, rank, skill
                ),
                linkStyle = {rankColor, rankColor, false}
            })
        end
    end
    
    -- Top sailing rows (one per route)
    if info.top_sailing and next(info.top_sailing) then
        for route, rank in pairs(info.top_sailing) do
            local rankColor = rank == 1 and "gold" or "silver"
            -- Extract port names from route (e.g., "Tristeza • Asahi" -> "Tristeza", "Asahi")
            local port1, port2 = route:match("^%s*(.-)%s*•%s*(.-)%s*$")
            -- Use last word of each port name (lowercased) for server's sscanf parsing
            local port1Short = port1:match("(%S+)$"):lower()
            local port2Short = port2:match("(%S+)$"):lower()
            table.insert(rows, {
                height = smallLineHeight,
                content = string.format(
                    [[<center><a href="send:shiptop route %s %s"><font size="2" color="%s">#%d ⛵ %s</font></a></center>]],
                    port1Short, port2Short, rankColor, rank, route
                ),
                linkStyle = {rankColor, rankColor, false}
            })
        end
    end
    
    -- Calculate total height
    local totalHeight = padding
    for _, row in ipairs(rows) do
        totalHeight = totalHeight + row.height
    end
    totalHeight = totalHeight + padding
    
    -- Resize popup
    GUI.PlayerDetailPopup:resize(nil, totalHeight)
    
    -- Hide any extra labels from previous render
    if GUI.PlayerDetailPopupLabels then
        for i = #rows + 1, #GUI.PlayerDetailPopupLabels do
            if GUI.PlayerDetailPopupLabels[i] then
                GUI.PlayerDetailPopupLabels[i]:hide()
            end
        end
    else
        GUI.PlayerDetailPopupLabels = {}
    end
    
    -- Create or update labels for each row with absolute positioning
    local currentY = padding
    for i, row in ipairs(rows) do
        local labelName = "GUI.PlayerDetailPopupRow" .. i
        
        if GUI.PlayerDetailPopupLabels[i] then
            -- Reuse existing label
            GUI.PlayerDetailPopupLabels[i]:move(0, currentY .. "px")
            GUI.PlayerDetailPopupLabels[i]:resize("100%", row.height .. "px")
            GUI.PlayerDetailPopupLabels[i]:echo(row.content)
            -- TODO: Uncomment when Mudlet 4.20+ is released
            -- if row.linkStyle and GUI.PlayerDetailPopupLabels[i].setLinkStyle then
            --     GUI.PlayerDetailPopupLabels[i]:setLinkStyle(row.linkStyle[1], row.linkStyle[2], row.linkStyle[3])
            -- end
            GUI.PlayerDetailPopupLabels[i]:show()
            GUI.PlayerDetailPopupLabels[i]:raise()
        else
            -- Create new label
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
        end
        
        currentY = currentY + row.height
    end
    
    -- Create/update AFK status indicator overlay on avatar
    if info.afk ~= nil then
        local statusLabelName = "GUI.PlayerDetailPopupAFKStatus"
        
        -- Calculate position (bottom-right corner of avatar)
        local popupWidth = getPopupWidth()
        local avatarHalfWidth = 32  -- 64px / 2
        local avatarSize = 64
        local statusSize = 16  -- Smaller size for less intrusion
        local statusX = (popupWidth / 2) + avatarHalfWidth - statusSize - 2  -- Inside avatar right edge
        local statusY = padding + avatarSize - statusSize - 2  -- Inside avatar bottom edge
        
        -- Always recreate the label to ensure it displays properly
        if GUI.PlayerDetailPopupAFKStatus then
            GUI.PlayerDetailPopupAFKStatus:hide()
            GUI.PlayerDetailPopupAFKStatus = nil
        end
        
        GUI.PlayerDetailPopupAFKStatus = Geyser.Label:new({
            name = statusLabelName,
            x = statusX,
            y = statusY,
            width = statusSize,
            height = statusSize,
        }, GUI.PlayerDetailPopup)
        
        -- Set style and content based on AFK status
        if info.afk == 0 then
            -- Active - sun emoji on dark blue circle
            GUI.PlayerDetailPopupAFKStatus:setStyleSheet([[
                background-color: #1a237e;
                border: 2px solid #0d1440;
                border-radius: 8px;
                font-size: 10px;
            ]])
            GUI.PlayerDetailPopupAFKStatus:echo([[<center>☀️</center>]])
        elseif info.afk == 1 then
            -- Away - dark blue circle with moon emoji
            GUI.PlayerDetailPopupAFKStatus:setStyleSheet([[
                background-color: #1a237e;
                border: 2px solid #0d1440;
                border-radius: 8px;
                font-size: 10px;
            ]])
            GUI.PlayerDetailPopupAFKStatus:echo([[<center>🌙</center>]])
        end
        
        -- Prevent clicks from closing the popup
        GUI.PlayerDetailPopupAFKStatus:setClickCallback(function() end)
        
        GUI.PlayerDetailPopupAFKStatus:show()
        GUI.PlayerDetailPopupAFKStatus:raise()
    elseif GUI.PlayerDetailPopupAFKStatus then
        GUI.PlayerDetailPopupAFKStatus:hide()
    end
    
    -- Create/update OPK indicator overlay to the right of avatar
    if info.opt_in_pk == 1 then
        local opkLabelName = "GUI.PlayerDetailPopupOPK"
        
        -- Calculate position (right of avatar, halfway to border)
        local popupWidth = getPopupWidth()
        local avatarRightEdge = (popupWidth / 2) + 32  -- Center + half avatar width
        local rightMargin = 10  -- Border padding
        local availableSpace = popupWidth - avatarRightEdge - rightMargin
        local opkWidth = 32
        local opkHeight = 18
        
        -- Only show OPK indicator if there's enough space
        if availableSpace < opkWidth + 10 then
            if GUI.PlayerDetailPopupOPK then
                GUI.PlayerDetailPopupOPK:hide()
            end
        else
            local opkX = avatarRightEdge + (availableSpace / 2) - (opkWidth / 2)  -- Centered in available space
            local opkY = padding + 32 - (opkHeight / 2)  -- Vertically centered on avatar
            
            -- Always recreate the label to ensure it displays properly
            if GUI.PlayerDetailPopupOPK then
                GUI.PlayerDetailPopupOPK:hide()
                GUI.PlayerDetailPopupOPK = nil
            end
            
            GUI.PlayerDetailPopupOPK = Geyser.Label:new({
                name = opkLabelName,
                x = opkX,
                y = opkY,
                width = opkWidth,
                height = opkHeight,
            }, GUI.PlayerDetailPopup)
            
            GUI.PlayerDetailPopupOPK:setStyleSheet([[
                background-color: #cc0000;
                border: 1px solid #880000;
                border-radius: 3px;
                qproperty-alignment: 'AlignCenter';
            ]])
            
            GUI.PlayerDetailPopupOPK:echo(string.format(
                [[<center> <a href="send:pkinfo %s"><font size="2" color="white"><b>OPK</b></font></a> </center>]],
                info.name:lower()
            ))
            
            -- Prevent clicks from closing the popup (but allow link clicks)
            GUI.PlayerDetailPopupOPK:setClickCallback(function() end)
            
            GUI.PlayerDetailPopupOPK:show()
            GUI.PlayerDetailPopupOPK:raise()
        end
    elseif GUI.PlayerDetailPopupOPK then
        GUI.PlayerDetailPopupOPK:hide()
    end
end