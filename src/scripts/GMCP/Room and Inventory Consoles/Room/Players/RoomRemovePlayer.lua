function RoomRemovePlayer()
  playerKey = gmcp.Room.RemovePlayer
  roomPlayersTable["" .. playerKey] = nil
  UpdateRoomConsole()
end