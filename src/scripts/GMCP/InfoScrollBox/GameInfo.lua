-- Data table for character status icons mapped by event
local info_data = {
    boom = "001-boom.png",
    rip = "002-grave.png",
    level = "003-level-up.png",
    winner = "004-winner.png",
    trophy = "005-trophy.png",
    rank = "006-top-three.png",
    fireworks1 = "007-fireworks.png",
    fireworks2 = "008-fireworks-1.png",
    party = "009-party-popper.png",
    egg_colored = "010-easter-egg.png",
    egg_white = "011-easter-egg1.png",
    flag_white = "012-red-flag.png",
    flag_blue = "022-flag.png",
    flag_red = "023-red-flag-1.png",
    clover4 = "013-clover.png",
    clover3 = "014-shamrock.png",
    delivery = "015-delivery.png",
    turkey = "016-turkey.png",
    zombie = "017-zombie.png",
    werewolf = "018-werewolf.png",
    vampire_male = "019-vampire.png",
    vampire_female = "020-people.png",
    trooper = "021-droid.png"
}

-- Define CSS for Game Info List
GUI.GameInfoCSS = CSSMan.new([[
	qproperty-wordWrap: true;
	qproperty-alignment: 'AlignCenter';
]])

-- Function to display Game Info HTML
function GameInfo()
    local game_info = gmcp.Game and gmcp.Game.Info
    local icon_path = getMudletHomeDir() .. "/StickMUD/"
    local gameInfo = "<center>"

    if nextContentBox ~= "BoxInfo" then
        local next = nextContentBox;
        tempTimer(3.0, function()
            on_content_box_press(next)
            if GUI.GameInfoLabel then
                GUI.GameInfoLabel:echo("");
            end
        end)
    end

    on_content_box_press("BoxInfo")

    -- Display icon based on game event if available
    if game_info and info_data[game_info.event] then
        gameInfo = string.format('<img src="%s%s">', icon_path, info_data[game_info.event])
    end

    -- Set up and display the game info label in the GUI
    GUI.GameInfoLabel = Geyser.Label:new({
        name = "GUI.GameInfoLabel",
        x = 0, y = 0, width = "100%", height = "100%",
        message = gameInfo
    }, GUI.InfoScrollBox)
    GUI.GameInfoLabel:setStyleSheet(GUI.GameInfoCSS:getCSS())
    setBackgroundColor("GUI.GameInfoLabel", 0, 0, 0)
end