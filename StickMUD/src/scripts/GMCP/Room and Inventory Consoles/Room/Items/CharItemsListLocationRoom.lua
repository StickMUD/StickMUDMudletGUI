function CharItemsListLocationRoom()
  if gmcp.Char.Items.List.location == "room" then
    roomNPCsTable = {}
    roomInvTable = {}
    if (gmcp.Char.Items.List.items ~= "") then
      for key, value in pairs(gmcp.Char.Items.List.items) do
        local highlight = getItemHighlight(value) or ""
        if value.attrib == "W" then
          roomNPCsTable[value.id] = highlight .. value.name
        else
          roomInvTable[value.id] = highlight .. value.name
        end
      end
    end
    UpdateRoomConsole()
  end
end