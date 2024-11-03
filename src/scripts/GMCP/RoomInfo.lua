function RoomInfo()
    local name = gmcp.Room.Info.name or "Room"
    local area = gmcp.Room.Info.area or "Area"
    local exits = gmcp.Room.Info.exits or {}

    GUI.BoxRoom:echo(
        string.format("<center><font size=\"4\">📍</font> <b><font size=\"3\">%s</font></b></center>", name)
    )
    GUI.BoxArea:echo(
        string.format("<center><font size=\"4\">🏰</font> <b><font size=\"3\">%s</font></b></center>", area)
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

    local directionsText = #directions > 0 and table.concat(directions, ", ") or "No obvious exits"
    GUI.BoxExits:echo(
        string.format("<center><font size=\"4\">🚪</font> <b><font size=\"3\">%s</font></b></center>", directionsText)
    )
end
