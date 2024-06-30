function CharItemsRemoveLocationRoom()
	if gmcp.Char.Items.Remove.location == "room" then
		itemKey = gmcp.Char.Items.Remove.item.id
		roomInvTable["" .. itemKey] = nil
		roomNPCsTable["" .. itemKey] = nil
		UpdateRoomConsole()
	end
end