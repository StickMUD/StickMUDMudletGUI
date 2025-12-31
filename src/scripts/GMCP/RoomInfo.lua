-- Initialize room display to default/empty state
function InitializeRoomInfo()
    local pillCSS = GUI.FooterPillCSS or "background-color: #252528; border: 1px solid #3a3a3f; border-radius: 12px; padding: 4px 12px; margin: 4px 8px;"
    if GUI.BoxRoom then
        GUI.BoxRoom:echo(string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">📍</font>&nbsp;&nbsp;<font size="3" color="white"><b>-</b></font>&nbsp;</span></center>]], pillCSS))
    end
    if GUI.BoxArea then
        GUI.BoxArea:echo(string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">🏰</font>&nbsp;&nbsp;<font size="3" color="white"><b>-</b></font>&nbsp;</span></center>]], pillCSS))
    end
    if GUI.BoxExits then
        GUI.BoxExits:echo(string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">🚪</font>&nbsp;&nbsp;<font size="3" color="white"><b>-</b></font>&nbsp;</span></center>]], pillCSS))
    end
end

function RoomInfo()
    -- Check if GMCP Room.Info data is available
    if not gmcp or not gmcp.Room or not gmcp.Room.Info then
        InitializeRoomInfo()
        return
    end

    local name = gmcp.Room.Info.name or "Room"
    local area = gmcp.Room.Info.area or "Area"
    local exits = gmcp.Room.Info.exits or {}

    local pillCSS = GUI.FooterPillCSS or "background-color: #252528; border: 1px solid #3a3a3f; border-radius: 12px; padding: 4px 12px; margin: 4px 8px;"
    GUI.BoxRoom:echo(
        string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">📍</font>&nbsp;&nbsp;<font size="3" color="white"><b>%s</b></font>&nbsp;</span></center>]], pillCSS, name)
    )
    GUI.BoxArea:echo(
        string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">🏰</font>&nbsp;&nbsp;<font size="3" color="white"><b>%s</b></font>&nbsp;</span></center>]], pillCSS, area)
    )

    local exitAbbreviations = {
        north = "n", northeast = "ne", east = "e", southeast = "se",
        south = "s", southwest = "sw", west = "w", northwest = "nw",
        up = "u", down = "d"
    }

    local directions = {}
    for dir in pairs(exits) do
        table.insert(directions, exitAbbreviations[dir] or dir)
    end

    local directionsText = #directions > 0 and table.concat(directions, ", ") or "none"
    GUI.BoxExits:echo(
        string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">🚪</font>&nbsp;&nbsp;<font size="3" color="white"><b>%s</b></font>&nbsp;</span></center>]], pillCSS, directionsText)
    )
end
