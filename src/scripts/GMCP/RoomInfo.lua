function RoomInfo()
    local name = gmcp.Room.Info.name or "Room"
    local area = gmcp.Room.Info.area or "Area"
    local exits = gmcp.Room.Info.exits or {}

    GUI.BoxRoom:echo(
        "<center><font size=\"4\">img src=\"" .. getMudletHomeDir() ..
            "/StickMUD/047-user.png\"></font> <b><font size=\"3\">" .. name ..
            "</font></b></center>")
    GUI.BoxArea:echo("<center><font size=\"4\"><img src=\"" ..
                         getMudletHomeDir() ..
                         "/StickMUD/048-tour.png\"></font> <b><font size=\"3\">" ..
                         area .. "</font></b></center>")

    local directions = nil

    for k, _ in pairs(exits) do
        local dir

        if k == "north" then
            dir = "n"
        elseif k == "northeast" then
            dir = "ne"
        elseif k == "east" then
            dir = "e"
        elseif k == "southeast" then
            dir = "se"
        elseif k == "south" then
            dir = "s"
        elseif k == "southwest" then
            dir = "sw"
        elseif k == "west" then
            dir = "w"
        elseif k == "northwest" then
            dir = "nw"
        elseif k == "up" then
            dir = "u"
        elseif k == "down" then
            dir = "d"
        else
            dir = k
        end

        if directions ~= nil then
            directions = directions .. ", " .. dir
        else
            directions = dir
        end
    end

    if directions == nil then directions = "No obvious exits" end

    GUI.BoxExits:echo("<center><font size=\"4\"><img src=\"" ..
                          getMudletHomeDir() ..
                          "/StickMUD/046-exit.png\"></font> <b><font size=\"3\">" ..
                          directions .. "</font></b></center>")
end
