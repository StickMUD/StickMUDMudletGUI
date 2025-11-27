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
                    <br><font size="3" color="silver">%s %s</font>
                    <br><font size="3" color="gray">Level %d</font>
    ]], getGuildImagePath(info.guild, info.gender),
        firstToUpper(info.name),
        firstToUpper(info.race),
        firstToUpper(info.guild),
        info.level)
    
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
    
    popupContent = popupContent .. [[
                </td>
            </tr>
        </table>
    ]]
    
    GUI.PlayerDetailPopup:echo(popupContent)
end
