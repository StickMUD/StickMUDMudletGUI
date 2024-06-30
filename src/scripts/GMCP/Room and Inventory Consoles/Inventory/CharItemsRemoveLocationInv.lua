function CharItemsRemoveLocationInv()
  if gmcp.Char.Items.Remove.location == "inv" then
    itemKey = gmcp.Char.Items.Remove.item.id
    wornArmour["" .. itemKey] = nil
    wieldedWeapons["" .. itemKey] = nil
    otherInventory["" .. itemKey] = nil
    UpdateInventoryConsole()
  end
end