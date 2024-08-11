chat_sections =
  {"BoxChatAll", "BoxChatGuild", "BoxChatClan", "BoxChatTells", "BoxChatLocal", "BoxChatClear"}
chat_icons = {"📜", "🧙", "👪", "💬", "📍", "🗑️"}
chat_tooltips = {"All", "Guild", "Clan", "Tells", "Local", "Clear"}
chat_consoles =
  {
    "ChatAllConsole",
    "ChatGuildConsole",
    "ChatClanConsole",
    "ChatTellsConsole",
    "ChatLocalConsole",
    "ChatClearConsole"
  }

function on_chat_box_press(section)
  for index = 1, #chat_sections - 1 do
    local section_value = chat_sections[index]
    local console_value = chat_consoles[index]
		
    if section == "BoxChatClear" then
      clearWindow("GUI." .. console_value)
    elseif section_value == section then
      GUI[console_value]:show()
    else
      GUI[console_value]:hide()
    end
  end
end

GUI.BoxChatButtonCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]])

-- The icons will be contained here
GUI.HBoxChat =
  Geyser.HBox:new({name = "GUI.HBoxChat", x = 0, y = 0, width = "50%", height = "5%"}, GUI.Right)
	
-- Add the icons and events
for index = 1, #chat_sections do
  local section_value = chat_sections[index]
  local icon_value = chat_icons[index]
  local tooltip_value = chat_tooltips[index]
	
  GUI[section_value] =
    Geyser.Label:new(
      {
        name = "GUI." .. section_value,
        message = "<center><font size=\"6\">" .. icon_value .. "</font></center>",
      },
      GUI.HBoxChat
    )
  GUI[section_value]:setStyleSheet(GUI.BoxChatButtonCSS:getCSS())
  GUI[section_value]:setClickCallback("on_chat_box_press", section_value)
  GUI[section_value]:setOnEnter(
    "enable_tooltip",
    GUI[section_value],
    "<center><b><font size=\"3\">" .. icon_value .. "</font></b><br>" .. tooltip_value
  )
  GUI[section_value]:setOnLeave(
    "disable_tooltip",
    GUI[section_value],
    "<center><b><font size=\"6\">" .. icon_value .. "</font></b>"
  )
end

-- The consoles will be contained here
GUI.ChatBox =
  Geyser.Label:new(
    {name = "GUI.ChatBox", x = 0, y = "5%", width = "50%", height = "40%"}, GUI.Right
  )
GUI.ChatBox:setStyleSheet(GUI.BoxRightCSS:getCSS())

-- Add the consoles
for index = 1, #chat_sections - 1 do
  local console_value = chat_consoles[index]
	
  GUI[console_value] =
    GUI[console_value] or
    Geyser.MiniConsole:new(
      {
        name = "GUI." .. console_value,
        x = GUI.ChatBox:get_x(),
        y = GUI.ChatBox:get_y(),
        height = GUI.ChatBox:get_height(),
        width = GUI.ChatBox:get_width(),
      }
    )
  setBackgroundColor("GUI." .. console_value, 0, 0, 0, 0)

  if gmcp.Game.Variables.Font ~= nil and getAvailableFonts()[gmcp.Game.Variables.Font] then
    setFont("GUI." .. console_value, gmcp.Game.Variables.Font)
  end

  if gmcp.Game.Variables.FontSize ~= nil then
    setMiniConsoleFontSize("GUI." .. console_value, gmcp.Game.Variables.FontSize)
  elseif getOS() == "mac" then
    setMiniConsoleFontSize("GUI." .. console_value, 10)
  else
    setMiniConsoleFontSize("GUI." .. console_value, 8)
  end
  setFgColor("GUI." .. console_value, 192, 192, 192)
  setBgColor("GUI." .. console_value, 0, 0, 0)
  GUI[console_value]:enableAutoWrap()
  GUI[console_value]:hide()
end

on_chat_box_press("BoxChatAll")