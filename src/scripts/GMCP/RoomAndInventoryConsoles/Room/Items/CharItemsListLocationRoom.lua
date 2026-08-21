function CharItemsListLocationRoom()
  if gmcp.Char.Items.List.location == "room" then
    roomNPCsTable = {}
    roomInvTable = {}
    if (gmcp.Char.Items.List.items ~= "") then
      for key, value in pairs(gmcp.Char.Items.List.items) do
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
      end
    end
    UpdateRoomConsole()
  end
end