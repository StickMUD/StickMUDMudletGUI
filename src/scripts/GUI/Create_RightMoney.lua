-- Container for money display
GUI.HBoxMoney = Geyser.HBox:new({
  name = "GUI.HBoxMoney",
  x = 0, y = "89%", width = "50%", height = "5%"
}, GUI.Right)

-- Pill style CSS for money boxes
GUI.MoneyPillCSS = [[
  background-color: #222230;
  border: 1px solid #32323f;
  border-radius: 10px;
  margin: 2px 4px;
]]

-- Helper function to create money boxes
local function createMoneyBox(name, icon, callback, parent)
  GUI[name] = Geyser.Label:new({
      name = "GUI." .. name,
      message = string.format([[<center><span style="%s">&nbsp;<font size="3" color="#888">%s</font>&nbsp;<font size="3" color="white"><b>?</b></font>&nbsp;</span></center>]], GUI.MoneyPillCSS, icon)
  }, parent)
  GUI[name]:setStyleSheet([[background-color: rgba(0,0,0,0);]])
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
