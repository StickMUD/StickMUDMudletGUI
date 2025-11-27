wieldedWeapons = {}
wornArmour = {}
otherInventory = {}

local function setupConsole(consoleName)
    -- Check if console exists before clearing
    if not GUI or not content_preferences[consoleName] then
        return false
    end
    
    clearUserWindow(consoleName)
    setFont(consoleName, getFont())
    setMiniConsoleFontSize(consoleName, content_preferences[consoleName].fontSize)

    -- Use string.match to split the string
    local prefix, suffix = string.match(consoleName, "^(%w+)%.(%w+)$")
    if _G[prefix] and _G[prefix][suffix] then
        _G[prefix][suffix]:resetAutoWrap() -- Use _G to access the global variable by name
    end
    return true
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

-- Initialize inventory consoles to default empty state
function InitializeInventoryConsoles()
    if setupConsole("GUI.WieldedWeaponsConsole") then
        cecho("GUI.WieldedWeaponsConsole", "\n<gray>Wielded Weapons:\n\n  No data yet...\n")
    end
    if setupConsole("GUI.WornArmourConsole") then
        cecho("GUI.WornArmourConsole", "\n<gray>Worn Armours:\n\n  No data yet...\n")
    end
    if setupConsole("GUI.InventoryConsole") then
        cecho("GUI.InventoryConsole", "\n<gray>Other Items:\n\n  No data yet...\n")
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