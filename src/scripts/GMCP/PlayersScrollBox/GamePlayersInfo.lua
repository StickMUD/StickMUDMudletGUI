-- Handle Game.Players.Info GMCP response
-- Updates the player detail popup with additional information

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
end
