function CharItemsListLocationInv()
  -- Check if GMCP Char.Items.List data is available
  if not gmcp or not gmcp.Char or not gmcp.Char.Items or not gmcp.Char.Items.List then
    return
  end
  
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