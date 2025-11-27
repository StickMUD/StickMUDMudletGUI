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
    local avatarHeight = 64      -- Avatar image
    local topPadding = 10        -- Padding above avatar
    local avatarMargin = 8       -- Space between avatar and text
    local nameLineHeight = 20    -- Name (font size 4)
    local infoLineHeight = 16    -- Info lines (font size 3)
    local smallLineHeight = 14   -- Small lines (font size 2)
    local bottomPadding = 12     -- Padding at bottom
    
    -- Start with base elements: avatar + name + race/guild/level line
    local totalHeight = topPadding + avatarHeight + avatarMargin + nameLineHeight + infoLineHeight
    
    -- Add height for each optional field
    if info.alignment then totalHeight = totalHeight + infoLineHeight end
    if info.age then totalHeight = totalHeight + infoLineHeight end
    if info.clan_name then totalHeight = totalHeight + infoLineHeight end
    if info.noble_title then totalHeight = totalHeight + infoLineHeight end
    if info.deity then totalHeight = totalHeight + infoLineHeight end
    if info.top_rankings and next(info.top_rankings) then 
        totalHeight = totalHeight + smallLineHeight 
    end
    
    totalHeight = totalHeight + bottomPadding
    
    GUI.PlayerDetailPopup:resize(nil, totalHeight)
    
    -- Build the popup content with additional details
    local popupContent = string.format([[
        <table width="100%%" height="100%%">
            <tr>
                <td colspan="2" valign="middle" align="center">
                    <img src="%s" width="64" height="64">
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top" align="center">
                    <font size="4" color="white"><b>%s</b></font>
                    <br><font size="3" color="silver">%s %s - Level %d</font>
    ]], getGuildImagePath(info.guild, info.gender),
        firstToUpper(info.name),
        firstToUpper(info.race),
        firstToUpper(info.guild),
        info.level)
    
    -- Add alignment if present
    if info.alignment then
        popupContent = popupContent .. string.format(
            [[<br><font size="3" color="gray">%s</font>]],
            firstToUpper(info.alignment)
        )
    end
    
    -- Add age if present
    if info.age then
        popupContent = popupContent .. string.format(
            [[<br><font size="3" color="gray">Age: %s</font>]],
            info.age
        )
    end
    
    -- Add clan info if present
    if info.clan_name then
        popupContent = popupContent .. string.format(
            [[<br><font size="3" color="cyan">%s</font>]],
            info.clan_name
        )
    end
    
    -- Add noble title and kingdom if present
    if info.noble_title then
        local kingdomText = ""
        if info.kingdom then
            if type(info.kingdom) == "table" then
                kingdomText = " of " .. table.concat(info.kingdom, ", ")
            else
                kingdomText = " of " .. firstToUpper(info.kingdom)
            end
        end
        popupContent = popupContent .. string.format(
            [[<br><font size="3" color="gold">%s%s</font>]],
            info.noble_title,
            kingdomText
        )
    end
    
    -- Add deity if present
    if info.deity then
        popupContent = popupContent .. string.format(
            [[<br><font size="3" color="magenta">Follower of %s</font>]],
            info.deity
        )
    end
    
    -- Add top rankings if present
    if info.top_rankings and next(info.top_rankings) then
        local rankings = {}
        for skill, rank in pairs(info.top_rankings) do
            local rankColor = rank == 1 and "gold" or "silver"
            table.insert(rankings, string.format(
                [[<font color="%s">#%d %s</font>]],
                rankColor, rank, skill
            ))
        end
        popupContent = popupContent .. string.format(
            [[<br><font size="2" color="orange">%s</font>]],
            table.concat(rankings, ", ")
        )
    end
    
    popupContent = popupContent .. [[
                </td>
            </tr>
        </table>
    ]]
    
    GUI.PlayerDetailPopup:echo(popupContent)
end
