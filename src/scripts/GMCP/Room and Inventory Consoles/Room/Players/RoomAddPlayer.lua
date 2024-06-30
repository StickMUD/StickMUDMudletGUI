function RoomAddPlayer()
  local value = gmcp.Room.AddPlayer
  local highlight = getPlayerHighlight(value) or ""
  roomPlayersTable[value.name] = highlight .. value.fullname
  UpdateRoomConsole()
end