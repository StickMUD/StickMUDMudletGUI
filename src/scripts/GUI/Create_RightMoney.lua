-- Container for money display
GUI.HBoxMoney = Geyser.HBox:new({
  name = "GUI.HBoxMoney",
  x = 0, y = "89%", width = "50%", height = "5%"
}, GUI.Right)

-- Helper function to create money boxes
local function createMoneyBox(name, icon, callback, parent)
  GUI[name] = Geyser.Label:new({
      name = "GUI." .. name,
      message = string.format("<center><b><font size=\"6\">%s</font></b> <b><font size=\"5\">?</font></b></center>", icon)
  }, parent)
  GUI[name]:setStyleSheet(GUI.BoxRightCSS:getCSS())
  GUI[name]:setClickCallback(callback)
end

-- Create Gold and Bank boxes
createMoneyBox("BoxGold", "💰", "on_boxgold_press", GUI.HBoxMoney)
createMoneyBox("BoxBank", "🏦", "on_boxbank_press", GUI.HBoxMoney)

-- Click callback functions
function on_boxgold_press()
  send("deposit all")
end

function on_boxbank_press()
  send("balance")
end
