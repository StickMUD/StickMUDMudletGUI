wieldedWeapons = {}
wornArmour = {}
otherInventory = {}

local function setupConsole(console)
    clearUserWindow(console)

    if gmcp.Game and gmcp.Game.Variables then
        local font = gmcp.Game.Variables.font
        if font and getAvailableFonts()[font] then
            setFont(console, font)
        end

        local fontSize = gmcp.Game.Variables.fontSize
        if fontSize then
            setMiniConsoleFontSize(console, fontSize)
        elseif getOS() == "mac" then
            setMiniConsoleFontSize(console, 10)
        else
            setMiniConsoleFontSize(console, 8)
        end
    end

    console:resetAutoWrap()
end

local function updateConsole(console, header, inventory)
    cecho(console, "\n<light_blue:black>" .. header .. ":\n\n")
    for key, value in pairs(inventory) do
        echo(console, " ")
        echoLink(console, "-", [[send("drop ]] .. key .. [[", false)]], "Drop", false)
        echo(console, " ( ")
        echoLink(console, "L", [[send("look at ]] .. key .. [[", false)]], "Look at", false)
        cecho(console, " ) " .. value .. "\n")
    end
end

function UpdateInventoryConsole()
    setupConsole(GUI.WieldedWeaponsConsole)
    updateConsole(GUI.WieldedWeaponsConsole, "Wielded Weapons", wieldedWeapons)

    setupConsole(GUI.WornArmourConsole)
    updateConsole(GUI.WornArmourConsole, "Worn Armours", wornArmour)

    setupConsole(GUI.InventoryConsole)
    updateConsole(GUI.InventoryConsole, "Other Items", otherInventory)
end