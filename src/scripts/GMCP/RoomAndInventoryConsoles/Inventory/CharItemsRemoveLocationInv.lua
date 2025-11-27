function CharItemsRemoveLocationInv()
  -- Check if GMCP Char.Items.Remove data is available
  if not gmcp or not gmcp.Char or not gmcp.Char.Items or not gmcp.Char.Items.Remove then
    return
  end
  
  if gmcp.Char.Items.Remove.location == "inv" then
    local itemKey = gmcp.Char.Items.Remove.item.id
    wornArmour["" .. itemKey] = nil
    wieldedWeapons["" .. itemKey] = nil
    otherInventory["" .. itemKey] = nil
    UpdateInventoryConsole()
  end
end