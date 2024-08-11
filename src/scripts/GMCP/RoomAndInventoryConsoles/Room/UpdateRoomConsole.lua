roomInvTable = {}
roomNPCsTable = {}
roomPlayersTable = {}

function UpdateRoomConsole()
  clearUserWindow("GUI.RoomConsole")
  if gmcp.Game ~= nil and gmcp.Game.Variables ~= nil and gmcp.Game.Variables.font ~= nil then
    if getAvailableFonts()[gmcp.Game.Variables.font] then
      setFont("GUI.RoomConsole", gmcp.Game.Variables.font)
    end
  end
  GUI.RoomConsole:resetAutoWrap()
	cecho("GUI.RoomConsole", "\n<light_blue:black>Your Location: <green_yellow:black>"..gmcp.Room.Info.name.."\n\n")
  for key, value in pairs(roomInvTable) do
    echo("GUI.RoomConsole", " ")
    echoLink("GUI.RoomConsole", "+", [[send("get ]] .. key .. [[", false)]], "Get", false)
    echo("GUI.RoomConsole", " ( ")
    echoLink("GUI.RoomConsole", "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
    cecho("GUI.RoomConsole", " ) " .. value .. "\n")
  end
	cecho("GUI.RoomConsole", "\n<light_blue:black>Non-Player Characters here:\n\n")
  for key, value in pairs(roomNPCsTable) do
    echo("GUI.RoomConsole", " ")
    echoLink("GUI.RoomConsole", "i", [[send("i ]] .. key .. [[", false)]], "Inventory", false)
    echo("GUI.RoomConsole", " ( ")
    echoLink("GUI.RoomConsole", "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
    cecho("GUI.RoomConsole", " ) " .. value .. "\n")
  end
	cecho("GUI.RoomConsole", "\n<light_blue:black>Players here:\n\n")
	for key, value in pairs(roomPlayersTable) do
    echo("GUI.RoomConsole", " ")
    echoLink("GUI.RoomConsole", "i", [[send("i ]] .. key .. [[", false)]], "Inventory", false)
    echo("GUI.RoomConsole", " ( ")
    echoLink("GUI.RoomConsole", "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
    cecho("GUI.RoomConsole", " ) " .. value .. "\n")
  end
end