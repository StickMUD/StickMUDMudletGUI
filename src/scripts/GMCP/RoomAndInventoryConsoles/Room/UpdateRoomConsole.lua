roomInvTable = {}
roomNPCsTable = {}
roomPlayersTable = {}

local function setupRoomConsole()
    clearUserWindow("GUI.RoomConsole")
    setFont("GUI.RoomConsole", getFont())
    setMiniConsoleFontSize("GUI.RoomConsole", content_preferences["GUI.RoomConsole"].fontSize)

    GUI.RoomConsole:resetAutoWrap()
    
    -- Check if GMCP Room.Info data is available
    local roomName = "Unknown"
    if gmcp and gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.name then
        roomName = gmcp.Room.Info.name
    end
    
    cecho("GUI.RoomConsole",
          "\n<light_blue:black>Your Location: <green_yellow:black>" ..
              roomName .. "\n\n")
end

local function updateRoomSection(consoleName, header, dataTable, getAction)
    cecho(consoleName, "\n<light_blue:black>" .. header .. ":\n\n")
    for key, value in pairs(dataTable) do
        echo(consoleName, " ")
        echoLink(consoleName, getAction,
                 [[send("get ]] .. key .. [[", false)]],
                 "Get", false)
        echo(consoleName, " ( ")
        echoLink(consoleName, "L", [[send("look at ]] .. key .. [[", false)]],
                 "Look at", false)
        cecho(consoleName, " ) " .. value .. "\n")
    end
end

function UpdateRoomConsole()
    setupRoomConsole()
    updateRoomSection("GUI.RoomConsole", "Room Inventory", roomInvTable, "+")
    updateRoomSection("GUI.RoomConsole", "Non-Player Characters here",
                      roomNPCsTable, "i")
    updateRoomSection("GUI.RoomConsole", "Players here", roomPlayersTable, "i")
end
