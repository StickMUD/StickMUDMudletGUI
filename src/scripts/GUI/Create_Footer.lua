-- CSS configurations
GUI.BoxFooterCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
  qproperty-wordWrap: true;
]])

GUI.GaugeBackCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: white;
  border-width: 1px;
  border-radius: 5px;
  margin: 5px;
]])

GUI.GaugeFrontCSS = CSSMan.new([[
  border-style: solid;
  border-color: white;
  border-width: 1px;
  border-radius: 5px;
  margin: 5px;
]])

-- Footer container
GUI.Footer = Geyser.VBox:new({
    name = "GUI.Footer",
    x = 0, y = 0, width = "100%", height = "100%"
}, GUI.Bottom)

GUI.FooterTop = Geyser.Container:new({name = "GUI.FooterTop"}, GUI.Footer)
GUI.FooterBottom = Geyser.HBox:new({name = "GUI.FooterBottom"}, GUI.Footer)

-- Helper function to create globally accessible icon labels with tooltips
local function createIconLabel(globalName, img, tooltip, xPos)
    GUI[globalName] = Geyser.Label:new({
        name = "GUI." .. globalName,
        message = string.format("<center><img src=\"%s/StickMUD/%s\">", getMudletHomeDir(), img),
        x = xPos, y = 0, width = "5%", height = "100%"
    }, GUI.FooterTop)
    GUI[globalName]:setStyleSheet(GUI.BoxFooterCSS:getCSS())
    GUI[globalName]:setOnEnter("enable_tooltip", GUI[globalName], string.format("<center><img src=\"%s/StickMUD/%s\"><br>%s", getMudletHomeDir(), img, tooltip))
    GUI[globalName]:setOnLeave("disable_tooltip", GUI[globalName], string.format("<center><img src=\"%s/StickMUD/%s\">", getMudletHomeDir(), img))
end

-- Helper function to create globally accessible gauges
local function createGauge(globalName, xPos, color)
    GUI[globalName] = Geyser.Gauge:new({
        name = "GUI." .. globalName,
        x = xPos, y = 0, width = "20%", height = "100%"
    }, GUI.FooterTop)
    GUI[globalName].back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
    GUI.GaugeFrontCSS:set("background-color", color)
    GUI[globalName].front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
    GUI[globalName]:setValue(math.random(100), 100)
end

-- Setup icons and gauges
createIconLabel("BoxHealth", "050-better-health.png", "Health", 0)
createGauge("HitPoints", "5%", "red")

createIconLabel("BoxMana", "052-potion.png", "Mana", "25%")
createGauge("SpellPoints", "30%", "blue")

createIconLabel("BoxFatigue", "051-stamina.png", "Endurance", "50%")
createGauge("FatiguePoints", "55%", "yellow")

createIconLabel("Target", "049-target.png", "Target", "75%")
createGauge("EnemyHealth", "80%", "purple")

-- Footer bottom labels for Room, Area, and Exits
local function createFooterLabel(globalName, icon, text)
    GUI[globalName] = Geyser.Label:new({name = "GUI." .. globalName}, GUI.FooterBottom)
    GUI[globalName]:setStyleSheet(GUI.BoxFooterCSS:getCSS())
    GUI[globalName]:echo(string.format("<center><font size=\"4\">%s</font> <b><font size=\"3\">%s</font></b></center>", icon, text))
end

createFooterLabel("BoxRoom", "📍", "Room")
createFooterLabel("BoxArea", "🏰", "Area")
createFooterLabel("BoxExits", "🚪", "Exits")
