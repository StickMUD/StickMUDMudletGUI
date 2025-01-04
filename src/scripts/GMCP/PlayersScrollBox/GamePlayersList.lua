-- Define CSS for Game Players List
GUI.GamePlayersListCSS = CSSMan.new([[
	qproperty-wordWrap: true;
	qproperty-alignment: 'AlignTop';
]])

-- Check if a value is a number
local function isNumber(value) return type(value) == 'number' end

-- Filter functions
local function filterByCoder(player) return isNumber(player.coder) and player.coder ~= 0 end
local function filterByPlayer(player) return not filterByCoder(player) end

-- Format large numbers
local function readableNumber(num, places)
    if not num then return "0" end
    local placeValue = ("%%.%df"):format(places or 0)
    if num >= 1e12 then return placeValue:format(num / 1e12) .. "T"
    elseif num >= 1e9 then return placeValue:format(num / 1e9) .. "B"
    elseif num >= 1e6 then return placeValue:format(num / 1e6) .. "M"
    elseif num >= 1e3 then return placeValue:format(num / 1e3) .. "k"
    else return tostring(num) end
end

-- Get image path based on guild and gender
local function getGuildImagePath(guild, gender)
    local basePath = getMudletHomeDir() .. "/StickMUD/"
    local images = {
        bard = gender == "female" and "066-musician.png" or "056-bard.png",
        fighter = gender == "female" and "070-girl.png" or "057-knight-2.png",
        healer = gender == "female" and "069-hippie-1.png" or "067-hippie.png",
        mage = gender == "female" and "068-magician.png" or "065-wizard.png",
        necromancer = gender == "female" and "071-skeleton.png" or "059-necromancer.png",
        ninja = gender == "female" and "062-ninja-1.png" or "058-ninja.png",
        priest = gender == "female" and "061-cross.png" or "060-priest.png",
        thief = gender == "female" and "063-people.png" or "064-man.png",
        default = "029-dazed.png"
    }
    return basePath .. (images[guild] or images.default)
end

-- Generate player entry HTML
local function generatePlayerEntry(player)
    local entry = string.format(
        "<tr><td width=\"20%%\" valign=\"center\" align=\"center\"><font size=\"8\"><img src=\"%s\"></font></td>" ..
        "<td width=\"80%%\" valign=\"center\" align=\"left\"><font size=\"4\">%s</font>",
        getGuildImagePath(player.guild, player.gender), firstToUpper(player.name)
    )
    entry = entry .. string.format(
        "<br><font size=\"3\" color=\"silver\">%s %s - Level %d</font>",
        firstToUpper(player.race), player.guild, player.level
    )
    if player.exprate_hour > 0 then
        entry = entry .. string.format(
            "<br><font size=\"3\" color=\"orange\"><i>%s/h exp</i></font>",
            readableNumber(player.exprate_hour)
        )
    end
    return entry .. "</td></tr>"
end

-- Create the Game Players List HTML
function GamePlayersList()
    local gamePlayersList = "<table>"
    local game_players_list = gmcp.Game and gmcp.Game.Players and gmcp.Game.Players.List or {}

    -- Immortals Section
    local coders = table.n_filter(game_players_list, filterByCoder)
    if #coders > 0 then
        table.sort(coders, function(a, b) return a.coder > b.coder end)
        gamePlayersList = gamePlayersList ..
            string.format("<tr><td colspan=\"2\"><font size=\"3\" color=\"gray\">IMMORTALS - %d</font></td></tr>", #coders)
        for _, player in ipairs(coders) do
            gamePlayersList = gamePlayersList .. generatePlayerEntry(player)
        end
    end

    -- Players Section
    local players = table.n_filter(game_players_list, filterByPlayer)
    if #players > 0 then
        table.sort(players, function(a, b) return a.level > b.level end)
        gamePlayersList = gamePlayersList ..
            string.format("<tr><td colspan=\"2\"><font size=\"3\" color=\"gray\">PLAYERS - %d</font></td></tr>", #players)
        for _, player in ipairs(players) do
            gamePlayersList = gamePlayersList .. generatePlayerEntry(player)
        end
    end

    gamePlayersList = gamePlayersList .. "</table>"

    -- Display the player list in the GUI
    GUI.GamePlayersListLabel = Geyser.Label:new({
        name = "GUI.GamePlayersListLabel",
        x = 0, y = 0, width = "100%", height = "400%"
    }, GUI.PlayersScrollBox)
    GUI.GamePlayersListLabel:setStyleSheet(GUI.GamePlayersListCSS:getCSS())
    setBackgroundColor("GUI.GamePlayersListLabel", 0, 0, 0)
    GUI.GamePlayersListLabel:echo(gamePlayersList)
end

on_menu_box_press("PlayersScrollBox")