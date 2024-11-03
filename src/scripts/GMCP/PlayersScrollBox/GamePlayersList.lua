GUI.GamePlayersListCSS = CSSMan.new([[
	qproperty-wordWrap: true;
  qproperty-alignment: 'AlignTop';
]])

local function isNumber(t) return t and type(t) == 'number' end

local function filterByCoder(player)
    if isNumber(player.coder) and player.coder ~= 0 then return true end
    return false
end

local function filterByPlayer(player)
    if isNumber(player.coder) and player.coder ~= 0 then return false end
    return true
end

local function readableNumber(num, places)
    local ret
    local placeValue = ("%%.%df"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000000 then
        ret = placeValue:format(num / 1000000000000) .. "T"
        -- trillion
    elseif num >= 1000000000 then
        ret = placeValue:format(num / 1000000000) .. "B"
        -- billion
    elseif num >= 1000000 then
        ret = placeValue:format(num / 1000000) .. "M"
        -- million
    elseif num >= 1000 then
        ret = placeValue:format(num / 1000) .. "k"
        -- thousand
    else
        ret = num
        -- hundreds
    end
    return ret
end

function GamePlayersList()
    local game_players_list = nil
    local gamePlayersList = "<table>"

    -- Check if gmcp.Game and gmcp.Game.Players and gmcp.Game.Players.List exist
    if gmcp.Game and gmcp.Game.Players and gmcp.Game.Players.List then
        game_players_list = gmcp.Game.Players.List
    end

    if game_players_list then
        local coders = table.n_filter(game_players_list, filterByCoder)
        if #coders > 0 then
            table.sort(coders, function(v1, v2)
                return v1.coder > v2.coder
            end)
            gamePlayersList = gamePlayersList ..
                                  "<tr><td colspan=\"2\"><font size=\"3\" color=\"gray\">IMMORTALS - "
            gamePlayersList = gamePlayersList .. #coders .. "</font></td></tr>"
            for k, v in pairs(coders) do
                gamePlayersList = gamePlayersList ..
                                      "<tr><td width=\"20%\" valign=\"center\" align=\"center\"><font size=\"8\"><img src=\""
                if v.guild == "bard" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/066-musician.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/056-bard.png\""
                    end
                elseif v.guild == "fighter" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/070-girl.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/057-knight-2.png\""
                    end
                elseif v.guild == "healer" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/069-hippie-1.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/067-hippie.png\""
                    end
                elseif v.guild == "mage" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/068-magician.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/065-wizard.png\""
                    end
                elseif v.guild == "necromancer" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/071-skeleton.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/059-necromancer.png\""
                    end
                elseif v.guild == "ninja" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/062-ninja-1.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/058-ninja.png\""
                    end
                elseif v.guild == "priest" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/061-cross.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/060-priest.png\""
                    end
                elseif v.guild == "thief" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/063-people.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/064-man.png\""
                    end
                else
                    gamePlayersList = gamePlayersList .. getMudletHomeDir() ..
                                          "/StickMUD/029-dazed.png\""
                end
                gamePlayersList = gamePlayersList .. "\"></font></td>"
                gamePlayersList = gamePlayersList ..
                                      "<td width=\"80%\" valign=\"center\" align=\"left\"><font size=\"4\">" ..
                                      firstToUpper(v.name) ..
                                      "</font></td></tr>"
            end
            gamePlayersList = gamePlayersList ..
                                  "<tr><td colspan=\"2\"></td></tr>"
        end
        local players = table.n_filter(game_players_list, filterByPlayer)
        if #players > 0 then
            table.sort(players, function(v1, v2)
                return v1.level > v2.level
            end)
            gamePlayersList = gamePlayersList ..
                                  "<tr><td colspan=\"2\"><font size=\"3\" color=\"gray\">PLAYERS - "
            gamePlayersList = gamePlayersList .. #players .. "</font></td></tr>"
            for k, v in pairs(players) do
                gamePlayersList = gamePlayersList ..
                                      "<tr><td width=\"20%\" valign=\"center\" align=\"center\"><font size=\"8\"><img src=\""
                if v.guild == "bard" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/066-musician.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/056-bard.png\""
                    end
                elseif v.guild == "fighter" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/070-girl.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/057-knight-2.png\""
                    end
                elseif v.guild == "healer" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/069-hippie-1.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/067-hippie.png\""
                    end
                elseif v.guild == "mage" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/068-magician.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/065-wizard.png\""
                    end
                elseif v.guild == "necromancer" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/071-skeleton.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/059-necromancer.png\""
                    end
                elseif v.guild == "ninja" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/062-ninja-1.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/058-ninja.png\""
                    end
                elseif v.guild == "priest" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/061-cross.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/060-priest.png\""
                    end
                elseif v.guild == "thief" then
                    if v.gender == "female" then
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/063-people.png\""
                    else
                        gamePlayersList =
                            gamePlayersList .. getMudletHomeDir() ..
                                "/StickMUD/064-man.png\""
                    end
                else
                    gamePlayersList = gamePlayersList .. getMudletHomeDir() ..
                                          "/StickMUD/029-dazed.png\""
                end
                gamePlayersList = gamePlayersList .. "\"></font></td>"
                gamePlayersList = gamePlayersList ..
                                      "<td width=\"80%\" valign=\"center\" align=\"left\"><font size=\"4\">" ..
                                      firstToUpper(v.name) .. "</font>"
                gamePlayersList = gamePlayersList ..
                                      "<br><font size=\"3\" color=\"silver\">" ..
                                      firstToUpper(v.race)
                gamePlayersList = gamePlayersList .. " " .. v.guild
                gamePlayersList = gamePlayersList .. " - Level " .. v.level
                gamePlayersList = gamePlayersList .. "</font>"
                if v.exprate_hour > 0 then
                    gamePlayersList = gamePlayersList ..
                                          "<br><font size=\"3\" color=\"orange\"><i>" ..
                                          readableNumber(v.exprate_hour) ..
                                          "/h exp</i></font>"
                end
                gamePlayersList = gamePlayersList .. "</td></tr>"
            end
        end
    end
    gamePlayersList = gamePlayersList .. "</table>"
    GUI.GamePlayersListLabel = Geyser.Label:new({
        name = "GUI.GamePlayersListLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "200%"
    }, GUI.PlayersScrollBox)
    GUI.GamePlayersListLabel:setStyleSheet(GUI.GamePlayersListCSS:getCSS());
    setBackgroundColor("GUI.GamePlayersListLabel", 0, 0, 0)
    GUI.GamePlayersListLabel:echo(gamePlayersList)
end

on_menu_box_press("PlayersScrollBox")
