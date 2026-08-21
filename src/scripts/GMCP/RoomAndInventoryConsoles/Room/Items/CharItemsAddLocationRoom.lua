function CharItemsAddLocationRoom()
  if gmcp.Char.Items.Add.location == "room" then
    local value = gmcp.Char.Items.Add.item
    local highlight = getItemHighlight(value) or ""
    -- "m" is the NPC code. This tested "W" - wearable armour - because that
    -- is what NPCs used to arrive as: gmcp_d.c classified anything answering
    -- query_armour() or query_clothing() before it checked for an NPC. The
    -- daemon tests identity first now, so this follows the documented legend,
    -- which ItemHighlighting.lua was already using.
    if value.attrib == "m" then
      roomNPCsTable[value.id] = highlight .. value.name
    else
      roomInvTable[value.id] = highlight .. value.name
    end
    UpdateRoomConsole()
  end
end