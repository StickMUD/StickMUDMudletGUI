function CharItemsListLocationInv()
  if gmcp.Char.Items.List.location == "inv" then
    wornArmour = {}
    wieldedWeapons = {}
		otherInventory = {}
    if (gmcp.Char.Items.List.items ~= "") then
      for key, value in pairs(gmcp.Char.Items.List.items) do
        local highlight = getItemHighlight(value) or ""
        if value.attrib == "w" then
          wornArmour[value.id] = highlight .. value.name
        elseif value.attrib == "l" then
          wieldedWeapons[value.id] = highlight .. value.name
        else
          otherInventory[value.id] = highlight .. value.name
        end
      end
    end
    UpdateInventoryConsole()
  end
end