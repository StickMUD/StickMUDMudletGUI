function CharItemsUpdateLocationInv()
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