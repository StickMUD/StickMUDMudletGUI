wieldedWeapons = {}
wornArmour = {}
otherInventory = {}

local function setupConsole(consoleName)
    clearUserWindow(consoleName)
    setFont(consoleName, getFont())
    setMiniConsoleFontSize(consoleName, getFontSize() - 2)

    -- Use string.match to split the string
    local prefix, suffix = string.match(consoleName, "^(%w+)%.(%w+)$")
    _G[prefix][suffix]:resetAutoWrap() -- Use _G to access the global variable by name
end

local function updateConsole(consoleName, header, inventory)
    cecho(consoleName, "\n<light_blue:black>" .. header .. ":\n\n")
    for key, value in pairs(inventory) do
        echo(consoleName, " ")
        echoLink(consoleName, "-", [[send("drop ]] .. key .. [[", false)]], "Drop", false)
        echo(consoleName, " ( ")
        echoLink(consoleName, "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
        cecho(consoleName, " ) " .. value .. "\n")
    end
end

function UpdateInventoryConsole()
    setupConsole("GUI.WieldedWeaponsConsole")
    updateConsole("GUI.WieldedWeaponsConsole", "Wielded Weapons", wieldedWeapons)

    setupConsole("GUI.WornArmourConsole")
    updateConsole("GUI.WornArmourConsole", "Worn Armours", wornArmour)

    setupConsole("GUI.InventoryConsole")
    updateConsole("GUI.InventoryConsole", "Other Items", otherInventory)
end