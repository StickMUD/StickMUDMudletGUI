wieldedWeapons = {}
wornArmour = {}
otherInventory = {}

local function setupConsole(consoleName)
    clearUserWindow(consoleName)

    if gmcp.Game and gmcp.Game.Variables then
        local font = gmcp.Game.Variables.font
        if font and getAvailableFonts()[font] then
            setFont(consoleName, font)
        end

        local fontSize = gmcp.Game.Variables.fontSize
        if fontSize then
            setMiniConsoleFontSize(consoleName, fontSize)
        elseif getOS() == "mac" then
            setMiniConsoleFontSize(consoleName, 10)
        else
            setMiniConsoleFontSize(consoleName, 8)
        end
    end

    _G[consoleName]:resetAutoWrap() -- Use _G to access the global variable by name
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