function RoomPlayers()
  roomPlayersTable = {}
  if (gmcp.Room.Players ~= "") then
    for key, value in pairs(gmcp.Room.Players) do
      local highlight = getPlayerHighlight(value) or ""
      roomPlayersTable[value.name] = highlight .. value.fullname
    end
  end
  UpdateRoomConsole()
end