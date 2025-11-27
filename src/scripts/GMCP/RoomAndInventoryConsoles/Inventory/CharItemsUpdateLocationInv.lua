function CharItemsUpdateLocationInv()
  -- Check if GMCP Char.Items.Update data is available
  if not gmcp or not gmcp.Char or not gmcp.Char.Items or not gmcp.Char.Items.Update then
    return
  end
  
  if gmcp.Char.Items.Update.location == "inv" then
    local value = gmcp.Char.Items.Update.item
		local itemKey = gmcp.Char.Items.Update.item.id
    local highlight = getItemHighlight(value) or ""
    if value.attrib == "w" then
      wornArmour[value.id] = highlight .. value.name
			otherInventory["" .. value.id] = nil
    elseif value.attrib == "l" then
      wieldedWeapons[value.id] = highlight .. value.name
			otherInventory["" .. value.id] = nil
    else
      otherInventory[value.id] = highlight .. value.name
			wornArmour["" .. value.id] = nil
			wieldedWeapons["" .. value.id] = nil
    end
    UpdateInventoryConsole()
  end
end