function CharItemsAddLocationRoom()
  if gmcp.Char.Items.Add.location == "room" then
    local value = gmcp.Char.Items.Add.item
    local highlight = getItemHighlight(value) or ""
    if value.attrib == "W" then
      roomNPCsTable[value.id] = highlight .. value.name
    else
      roomInvTable[value.id] = highlight .. value.name
    end
    UpdateRoomConsole()
  end
end