-- Data table for character status icons mapped by event
local info_data = {
    boom = "001-boom.png",
    grave = "002-grave.png",
    level = "003-level-up.png",
    winner = "004-winner.png",
    trophy = "005-trophy.png",
    rank = "006-top-three.png",
    fireworks1 = "007-fireworks.png",
    fireworks2 = "008-fireworks-1.png",
    party = "009-party-popper.png",
    coloredegg = "010-easter-egg.png",
    whiteegg = "011-easter-egg1.png",
    flag = "012-red-flag.png",
    fourleafclover = "013-clover.png",
    threeleafclover = "014-shamrock.png",
    delivery = "015-delivery.png",
    turkey = "016-turkey.png",
    zombie = "017-zombie.png",
    werewolf = "018-werewolf.png",
    vampire1 = "019-vampire.png",
    vampire2 = "020-people.png",
    trooper = "021-droid.png",
}

-- Define CSS for Game Info List
GUI.GameInfoCSS = CSSMan.new([[
	qproperty-wordWrap: true;
	qproperty-alignment: 'AlignTop';
]])

-- Function to display Game Info HTML
function GameInfo()
    local game_info = gmcp.Game and gmcp.Game.Info
    local icon_path = getMudletHomeDir() .. "/StickMUD/"
    local gameInfo = "<center>"

    if nextContentBox ~= "InfoScrollBox" then
        tempTimer(2.0, function()
            on_content_box_press(nextContentBox)
            if GUI.GameInfoLabel then
                GUI.GameInfoLabel:hide()
            end
        end)
    end

    on_content_box_press("InfoScrollBox")

    -- Display icon based on game event if available
    if game_info and info_data[game_info.event] then
        gameInfo = gameInfo .. string.format('<img src="%s%s">', icon_path, info_data[game_info.event])
    end

    -- Set up and display the game info label in the GUI
    GUI.GameInfoLabel = GUI.GameInfoLabel or Geyser.Label:new({
        name = "GUI.GameInfoLabel",
        x = 0, y = 0, width = "100%", height = "100%",
        message = gameInfo
    }, GUI.InfoScrollBox)
    GUI.GameInfoLabel:setStyleSheet(GUI.GameInfoCSS:getCSS())
    setBackgroundColor("GUI.GameInfoLabel", 0, 0, 0)
    GUI.GameInfoLabel:show()
end