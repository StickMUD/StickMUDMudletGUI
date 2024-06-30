wieldedWeapons = {}
wornArmour = {}
otherInventory = {}

function UpdateInventoryConsole()
  clearUserWindow("GUI.WieldedWeaponsConsole")
	GUI.WieldedWeaponsConsole:resetAutoWrap()
	cecho("GUI.WieldedWeaponsConsole", "\n<light_blue:black>Wielded Weapons:\n\n")
  for key, value in pairs(wieldedWeapons) do
    echo("GUI.WieldedWeaponsConsole", " ")
    echoLink("GUI.WieldedWeaponsConsole", "-", [[send("drop ]] .. key .. [[", false)]], "Drop", false)
    echo("GUI.WieldedWeaponsConsole", " ( ")
    echoLink("GUI.WieldedWeaponsConsole", "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
    cecho("GUI.WieldedWeaponsConsole", " ) " .. value .. "\n")
  end

  clearUserWindow("GUI.WornArmourConsole")
	GUI.WornArmourConsole:resetAutoWrap()	
	cecho("GUI.WornArmourConsole", "\n<light_blue:black>Worn Armours:\n\n")
  for key, value in pairs(wornArmour) do
    echo("GUI.WornArmourConsole", " ")
    echoLink("GUI.WornArmourConsole", "-", [[send("drop ]] .. key .. [[", false)]], "Drop", false)
    echo("GUI.WornArmourConsole", " ( ")
    echoLink("GUI.WornArmourConsole", "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
    cecho("GUI.WornArmourConsole", " ) " .. value .. "\n")
  end

  clearUserWindow("GUI.InventoryConsole")
	GUI.InventoryConsole:resetAutoWrap()	
	cecho("GUI.InventoryConsole", "\n<light_blue:black>Other Items:\n\n")
  for key, value in pairs(otherInventory) do
    echo("GUI.InventoryConsole", " ")
    echoLink("GUI.InventoryConsole", "-", [[send("drop ]] .. key .. [[", false)]], "Drop", false)
    echo("GUI.InventoryConsole", " ( ")
    echoLink("GUI.InventoryConsole", "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
    cecho("GUI.InventoryConsole", " ) " .. value .. "\n")
  end
end