-- Initialize status display to default/empty state
function InitializeStatus()
    if GUI.BoxGold then
        GUI.BoxGold:echo("<center><font size=\"3\">💰</font> <b><font size=\"4\">-</font></b></center>")
    end
    if GUI.BoxBank then
        GUI.BoxBank:echo("<center><font size=\"3\">🏦</font> <b><font size=\"4\">-</font></b></center>")
    end
end

function CharStatus()
    -- Check if GMCP Char.Status data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Status then
        InitializeStatus()
        return
    end

    local gold = gmcp.Char.Status.gold or "?"
    local bank = gmcp.Char.Status.bank or "?"

    GUI.BoxGold:echo(
        "<center><font size=\"3\">💰</font> <b><font size=\"4\">" .. gold ..
            "</font></b></center>")
    GUI.BoxBank:echo(
        "<center><font size=\"3\">🏦</font> <b><font size=\"4\">" .. bank ..
            "</font></b></center>")

    -- Enemy health now handled in CharVitals (updates every heartbeat)

    local char_status = {
        "brave", "pkable", "poisoned", "confused", "hallucinating", "drunk",
        "hunger", "thirst", "invis", "frog", "summonable", "rest"
    }

    local state

    for i = 1, 12 do
        state = gmcp.Char.Status[char_status[i]]

        GUI["Box" .. char_status[i] .. "CSS"] = CSSMan.new(
                                                    GUI.BoxRightCSS:getCSS())

        if char_status[i] == "rest" then
            if state == "Yes" then
                GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                          "rgba(0,0,255,100)")
            else
                GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                          "rgba(0,0,0,100)")
            end
        elseif char_status[i] == "invis" then
            if state == "Yes" then
                GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                          "rgba(0,0,255,100)")
            else
                GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                          "rgba(0,0,0,100)")
            end
        elseif char_status[i] == "frog" then
            if state == "Yes" then
                GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                          "rgba(0,0,255,100)")
            else
                GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                          "rgba(0,0,0,100)")
            end
        elseif state == "Yes" then
            GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                      "rgba(255,0,0,100)")
        else
            GUI["Box" .. char_status[i] .. "CSS"]:set("background-color",
                                                      "rgba(0,0,0,100)")
        end

        GUI["Box" .. firstToUpper(char_status[i])]:setStyleSheet(GUI["Box" ..
                                                                     char_status[i] ..
                                                                     "CSS"]:getCSS())
    end

    local icons = {
        "amulet", "armour", "belt", "boots", "bracers", "cloak", "gloves",
        "helmet", "leggings", "mask", "necklace", "ring", "ring2", "shield",
        "shoulders"
    }
    local icon_names = {
        "amulet", "armour", "belt", "boots", "bracers", "cloak", "gloves",
        "helmet", "leggings", "mask", "necklace", "ring", "ring 2", "shield",
        "shoulders"
    }
    local header_icons = {
        "001-amulet.png", "006-armour.png", "005-belt.png", "007-boots.png",
        "002-gauntlet.png", "008-cloak.png", "004-gauntlet-2.png",
        "009-helmet.png", "053-armor.png", "054-mask.png", "010-necklace.png",
        "012-magic-ring-1.png", "011-magic-ring.png", "013-knight.png",
        "014-body-armor.png"
    }
    local item

    for i = 1, 15 do
        item = gmcp.Char.Status[icons[i]]
        local icon_value = header_icons[i]

        GUI["Box" .. icons[i] .. "CSS"] = CSSMan.new(GUI.BoxHeaderCSS:getCSS())

        if item == "Yes" then
            GUI["Box" .. icons[i] .. "CSS"]:set("background-color",
                                                "rgba(0,0,255,100)")
        elseif item == "Damaged" then
            GUI["Box" .. icons[i] .. "CSS"]:set("background-color",
                                                "rgba(255,0,0,100)")
        else
            GUI["Box" .. icons[i] .. "CSS"]:set("background-color",
                                                "rgba(0,0,0,100)")
        end

        GUI["Box" .. firstToUpper(icons[i])]:setStyleSheet(
            GUI["Box" .. icons[i] .. "CSS"]:getCSS())
    end
end
