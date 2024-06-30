GUI.BoxFooterCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
	qproperty-wordWrap: true;
]])

GUI.Footer = Geyser.VBox:new({
  name = "GUI.Footer",
  x = 0, y = 0,
  width = "100%",
  height = "100%",
},GUI.Bottom)

GUI.FooterTop = Geyser.Container:new({
  name = "GUI.FooterTop",
},GUI.Footer)

GUI.FooterBottom = Geyser.HBox:new({
  name = "GUI.FooterBottom",
},GUI.Footer)

GUI.GaugeBackCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: white;
  border-width: 1px;
  border-radius: 5px;
  margin: 5px;
]])

GUI.GaugeFrontCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: white;
  border-width: 1px;
  border-radius: 5px;
  margin: 5px;
]])

GUI.BoxHealth = Geyser.Label:new({
  name = "GUI.BoxHealth",
	message = "<center><font size=\"6\">❤️</font></center>",
  x = 0, y = 0,
  width = "5%",
  height = "100%",
},GUI.FooterTop)
GUI.BoxHealth:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.BoxHealth:setOnEnter("enable_tooltip", GUI.BoxHealth, "<center><b><font size=\"4\">❤️</font></b><br>Health")
GUI.BoxHealth:setOnLeave("disable_tooltip", GUI.BoxHealth, "<center><b><font size=\"6\">❤️</font></b>")

GUI.HitPoints = Geyser.Gauge:new({
  name = "GUI.HitPoints",
  x = "5%", y = 0,
  width = "20%",
  height = "100%",
},GUI.FooterTop)
GUI.HitPoints.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
GUI.GaugeFrontCSS:set("background-color","red")
GUI.HitPoints.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
GUI.HitPoints:setValue(math.random(100),100)

GUI.BoxMana = Geyser.Label:new({
  name = "GUI.BoxMana",
	message = "<center><font size=\"6\">🔮</font></center>",
  x = "25%", y = 0,
  width = "5%",
  height = "100%",
},GUI.FooterTop)
GUI.BoxMana:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.BoxMana:setOnEnter("enable_tooltip", GUI.BoxMana, "<center><b><font size=\"4\">🔮</font></b><br>Mana")
GUI.BoxMana:setOnLeave("disable_tooltip", GUI.BoxMana, "<center><b><font size=\"6\">🔮</font></b>")

GUI.SpellPoints = Geyser.Gauge:new({
  name = "GUI.SpellPoints",
  x = "30%", y = 0,
  width = "20%",
  height = "100%",
},GUI.FooterTop)
GUI.SpellPoints.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
GUI.GaugeFrontCSS:set("background-color","blue")
GUI.SpellPoints.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
GUI.SpellPoints:setValue(math.random(100),100)

GUI.BoxFatigue = Geyser.Label:new({
  name = "GUI.BoxFatigue",
	message = "<center><font size=\"6\">⚡</font></center>",
  x = "50%", y = 0,
  width = "5%",
  height = "100%",
},GUI.FooterTop)
GUI.BoxFatigue:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.BoxFatigue:setOnEnter("enable_tooltip", GUI.BoxFatigue, "<center><b><font size=\"4\">⚡</font></b><br>Endurance")
GUI.BoxFatigue:setOnLeave("disable_tooltip", GUI.BoxFatigue, "<center><b><font size=\"6\">⚡</font></b>")

GUI.FatiguePoints = Geyser.Gauge:new({
  name = "GUI.Endurance",
  x = "55%", y = 0,
  width = "20%",
  height = "100%",
},GUI.FooterTop)
GUI.FatiguePoints.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
GUI.GaugeFrontCSS:set("background-color","yellow")
GUI.FatiguePoints.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
GUI.FatiguePoints:setValue(math.random(100),100)

GUI.Target = Geyser.Label:new({
  name = "GUI.Target",
	message = "<center><font size=\"6\">🎯️</font></center>",
  x = "75%", y = 0,
  width = "5%",
  height = "100%",
},GUI.FooterTop)
GUI.Target:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.Target:setOnEnter("enable_tooltip", GUI.Target, "<center><b><font size=\"4\">🎯️</font></b><br>Target")
GUI.Target:setOnLeave("disable_tooltip", GUI.Target, "<center><b><font size=\"6\">🎯️</font></b>")

GUI.EnemyHealth = Geyser.Gauge:new({
  name = "GUI.EnemyHealth",
  x = "80%", y = 0,
  width = "20%",
  height = "100%",
},GUI.FooterTop)
GUI.EnemyHealth.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
GUI.GaugeFrontCSS:set("background-color","purple")
GUI.EnemyHealth.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
GUI.EnemyHealth:setValue(math.random(100),100)

GUI.BoxRoom = Geyser.Label:new({
  name = "GUI.BoxRoom",
},GUI.FooterBottom)
GUI.BoxRoom:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.BoxRoom:echo("<center><font size=\"4\">📍</font> <b><font size=\"3\">Room</font></b></center>")

GUI.BoxArea = Geyser.Label:new({
  name = "GUI.BoxArea",
},GUI.FooterBottom)
GUI.BoxArea:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.BoxArea:echo("<center><font size=\"4\">🏰</font> <b><font size=\"3\">Area</font></b></center>")

GUI.BoxExits = Geyser.Label:new({
  name = "GUI.BoxExits",
},GUI.FooterBottom)
GUI.BoxExits:setStyleSheet(GUI.BoxFooterCSS:getCSS())
GUI.BoxExits:echo("<center><font size=\"4\">🚪</font> <b><font size=\"3\">Exits</font></b></center>")
