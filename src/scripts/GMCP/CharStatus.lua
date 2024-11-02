function CharStatus()
    local gold = gmcp.Char.Status.gold or "?"
    local bank = gmcp.Char.Status.bank or "?"
    local enemy = gmcp.Char.Status.enemy or "None"
    local current_enemy_health = gmcp.Char.Status.enemy_health
    local percent_enemy_health

    GUI.BoxGold:echo(
        "<center><font size=\"3\">💰</font> <b><font size=\"4\">" .. gold ..
            "</font></b></center>")
    GUI.BoxBank:echo(
        "<center><font size=\"3\">🏦</font> <b><font size=\"4\">" .. bank ..
            "</font></b></center>")

    if enemy == "None" then
        GUI.EnemyHealth:setValue(0, 100,
                                 ("<center><b>Enemy Health</b></center>"))
    else

        if current_enemy_health == "mortally wounded" then
            percent_enemy_health = 0
        elseif current_enemy_health == "nearly dead" then
            percent_enemy_health = 4
        elseif current_enemy_health == "in very bad shape" then
            percent_enemy_health = 10
        elseif current_enemy_health == "in bad shape" then
            percent_enemy_health = 20
        elseif current_enemy_health == "not in good shape" then
            percent_enemy_health = 50
        elseif current_enemy_health == "slightly hurt" then
            percent_enemy_health = 95
        elseif current_enemy_health == "in good shape" then
            percent_enemy_health = 100
        end

        GUI.EnemyHealth:setValue(percent_enemy_health, 100, ("<center><b>" ..
                                     enemy .. " is " .. current_enemy_health ..
                                     "</b></center>"))
    end

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
        "001-amulet.png", "006-armour.png", "005-belt.png",
        "007-boots.png", "002-gauntlet.png", "008-cloak.png", "004-gauntlet-2.png",
        "009-helmet.png", "053-armor.png", "054-mask.png", "010-necklace.png",
        "012-magic-ring-1.png", "011-magic-ring.png", "013-knight.png",
        "014-body-armor.png"
    }
    local item

    for i = 1, 15 do
        item = gmcp.Char.Status[icons[i]]
        local icon_value = header_icons[i]

        GUI["Box" .. icons[i] .. "CSS"] = CSSMan.new(GUI.BoxHeaderCSS:getCSS())
        GUI["Box" .. icons[i] .. "CSS"]:set("background-image", [[url(]] ..
                                                getMudletHomeDir() ..
                                                "/StickMUD/" .. icon_value ..
                                                [[)]])
        GUI["Box" .. icons[i] .. "CSS"]:set("background-repeat", "no-repeat")
        GUI["Box" .. icons[i] .. "CSS"]:set("background-origin", "margin")
        GUI["Box" .. icons[i] .. "CSS"]:set("background-position", "right")

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
