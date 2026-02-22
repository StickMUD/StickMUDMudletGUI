-- CSS configurations
GUI.BoxFooterCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
  qproperty-wordWrap: true;
]])

GUI.GaugeBackCSS = CSSMan.new([[
  background-color: #1a1a1a;
  border: 1px solid #333;
  border-radius: 4px;
  margin: 5px;
]])

GUI.GaugeFrontCSS = CSSMan.new([[
  border: none;
  border-radius: 4px;
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
    GUI[globalName]:setOnEnter("enable_tooltip", GUI[globalName], string.format("<center><img src=\"%s/StickMUD/%s\" width=\"24\" height=\"24\"><br>%s", getMudletHomeDir(), img, tooltip))
    GUI[globalName]:setOnLeave("disable_tooltip", GUI[globalName], string.format("<center><img src=\"%s/StickMUD/%s\">", getMudletHomeDir(), img))
end

-- Helper function to create globally accessible gauges
local function createGauge(globalName, xPos, fillColor, backColor)
    GUI[globalName] = Geyser.Gauge:new({
        name = "GUI." .. globalName,
        x = xPos, y = 0, width = "20%", height = "100%"
    }, GUI.FooterTop)
    GUI.GaugeBackCSS:set("background-color", backColor)
    GUI.GaugeBackCSS:set("border", "1px solid " .. backColor)
    GUI[globalName].back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
    GUI.GaugeFrontCSS:set("background-color", fillColor)
    GUI[globalName].front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
    GUI[globalName]:setValue(math.random(100), 100)
end

-- Setup icons and gauges
createIconLabel("BoxHealth", "050-better-health.png", "Health", 0)
createGauge("HitPoints", "5%", "#e74c3c", "#4a1a15")

createIconLabel("BoxMana", "052-potion.png", "Mana", "25%")
createGauge("SpellPoints", "30%", "#3498db", "#1a3a4d")

createIconLabel("BoxFatigue", "051-stamina.png", "Endurance", "50%")
createGauge("FatiguePoints", "55%", "#f39c12", "#4d3205")

createIconLabel("Target", "049-target.png", "Target", "75%")
createGauge("EnemyHealth", "80%", "#9b59b6", "#3d2347")

-- CSS for pill-style footer labels
GUI.FooterLabelCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
  qproperty-wordWrap: true;
]])

GUI.FooterPillCSS = [[
  background-color: #252528;
  border: 1px solid #3a3a3f;
  border-radius: 12px;
  padding: 4px 12px;
  margin: 4px 8px;
]]

-- Footer bottom labels for Room, Area, and Exits
local function createFooterLabel(globalName, icon, text, clickCommand)
    GUI[globalName] = Geyser.Label:new({name = "GUI." .. globalName}, GUI.FooterBottom)
    GUI[globalName]:setStyleSheet(GUI.FooterLabelCSS:getCSS())
    GUI[globalName]:echo(string.format(
        [[<center><span style="%s">&nbsp;<font size="3" color="#888">%s</font>&nbsp;&nbsp;<font size="3" color="white"><b>%s</b></font>&nbsp;</span></center>]],
        GUI.FooterPillCSS, icon, text
    ))
    if clickCommand then
        GUI[globalName]:setClickCallback(function() send(clickCommand) end)
    end
end

createFooterLabel("BoxRoom", "📍", "Room", "room")
createFooterLabel("BoxArea", "🏰", "Area", "area")
createFooterLabel("BoxExits", "🚪", "Exits", "scan")
-- Layout preset selector
function updateLayoutLabel()
    local preset = layout_settings.preset or "Normal"
    GUI.BoxLayout:echo(string.format(
        [[<center><span style="%s">&nbsp;<font size="3" color="#888">📐</font>&nbsp;&nbsp;<font size="3" color="white"><b>%s</b></font>&nbsp;</span></center>]],
        GUI.FooterPillCSS, preset
    ))
end

GUI.BoxLayout = Geyser.Label:new({name = "GUI.BoxLayout"}, GUI.FooterBottom)
GUI.BoxLayout:setStyleSheet(GUI.FooterLabelCSS:getCSS())
GUI.BoxLayout:setClickCallback(cycleLayoutPreset)
GUI.BoxLayout:setToolTip("Click to change layout (Compact/Normal/Wide)", "10")
updateLayoutLabel()

-- Wrap updateLayoutPanels to also update the label
local originalUpdateLayoutPanels = updateLayoutPanels
function updateLayoutPanels()
    originalUpdateLayoutPanels()
    updateLayoutLabel()
end