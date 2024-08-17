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
                                      "<tr><td width=\"20%\" valign=\"center\" align=\"center\"><font size=\"8\">"
                if v.guild == "bard" then
                    gamePlayersList = gamePlayersList .. "🪕"
                elseif v.guild == "fighter" then
                    gamePlayersList = gamePlayersList .. "⚔️"
                elseif v.guild == "healer" then
                    gamePlayersList = gamePlayersList .. "💝"
                elseif v.guild == "mage" then
                    gamePlayersList = gamePlayersList .. "🧙"
                elseif v.guild == "necromancer" then
                    gamePlayersList = gamePlayersList .. "💀"
                elseif v.guild == "ninja" then
                    gamePlayersList = gamePlayersList .. "🥷"
                elseif v.guild == "priest" then
                    gamePlayersList = gamePlayersList .. "⛪"
                elseif v.guild == "thief" then
                    gamePlayersList = gamePlayersList .. "😈"
                else
                    gamePlayersList = gamePlayersList .. "🤩"
                end
                gamePlayersList = gamePlayersList .. "</font></td>"
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
                                      "<tr><td width=\"20%\" valign=\"center\" align=\"center\"><font size=\"8\">"
                if v.guild == "bard" then
                    gamePlayersList = gamePlayersList .. "🪕"
                elseif v.guild == "fighter" then
                    gamePlayersList = gamePlayersList .. "⚔️"
                elseif v.guild == "healer" then
                    gamePlayersList = gamePlayersList .. "💝"
                elseif v.guild == "mage" then
                    gamePlayersList = gamePlayersList .. "🧙"
                elseif v.guild == "necromancer" then
                    gamePlayersList = gamePlayersList .. "💀"
                elseif v.guild == "ninja" then
                    gamePlayersList = gamePlayersList .. "🥷"
                elseif v.guild == "priest" then
                    gamePlayersList = gamePlayersList .. "⛪"
                elseif v.guild == "thief" then
                    gamePlayersList = gamePlayersList .. "😈"
                else
                    gamePlayersList = gamePlayersList .. "🤩"
                end
                gamePlayersList = gamePlayersList .. "</font></td>"
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