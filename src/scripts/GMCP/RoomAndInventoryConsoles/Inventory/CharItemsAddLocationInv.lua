function CharItemsAddLocationInv()
  -- Check if GMCP Char.Items.Add data is available
  if not gmcp or not gmcp.Char or not gmcp.Char.Items or not gmcp.Char.Items.Add then
    return
  end
  
  if gmcp.Char.Items.Add.location == "inv" then
    local value = gmcp.Char.Items.Add.item
    local highlight = getItemHighlight(value) or ""
    if value.attrib == "w" then
      wornArmour[value.id] = highlight .. value.name
    elseif value.attrib == "l" then
      wieldedWeapons[value.id] = highlight .. value.name
    else
      otherInventory[value.id] = highlight .. value.name
    end
    UpdateInventoryConsole()
  end
end