GUI.HBoxMoney =
  Geyser.HBox:new(
    {name = "GUI.HBoxMoney", x = 0, y = "89%", width = "50%", height = "5%"}, GUI.Right
  )
	
GUI.BoxGold =
  Geyser.Label:new(
    {
      name = "GUI.BoxGold",
      message =
        "<center><b><font size=\"6\"><img src=\"" .. getMudletHomeDir() ..
                              "/StickMUD/038-coin.png\" height=\"16px\" width = \"16px\"></font></b> <b><font size=\"5\">?</font></b></center>",
    },
    GUI.HBoxMoney
  )
GUI.BoxGold:setStyleSheet(GUI.BoxRightCSS:getCSS())
GUI.BoxGold:setClickCallback("on_boxgold_press")

function on_boxgold_press()
  send("deposit all");
end

GUI.BoxBank =
  Geyser.Label:new(
    {
      name = "GUI.BoxBank",
      message =
        "<center><b><font size=\"6\">img src=\"" .. getMudletHomeDir() ..
                              "/StickMUD/039-bank.png\" height=\"16px\" width = \"16px\"></font></b> <b><font size=\"5\">?</font></b></center>",
    },
    GUI.HBoxMoney
  )
GUI.BoxBank:setStyleSheet(GUI.BoxRightCSS:getCSS())
GUI.BoxBank:setClickCallback("on_boxbank_press")

function on_boxbank_press()
  send("balance");
end