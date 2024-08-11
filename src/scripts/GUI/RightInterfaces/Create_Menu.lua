menu_sections = {"BoxPlayers", "BoxAbilities", "BoxTraining", "BoxSession", "BoxGroup", "BoxHelp"}
menu_icons = {"🤺", "🤹", "🏆", "📈", "🐉", "📚"}
menu_tooltips = {"Players", "Abilities", "Training", "Session", "Party", "Help"}
menu_consoles =
  {
    "PlayersScrollBox",
    "AbilitiesConsole",
    "TrainingConsole",
    "SessionConsole",
    "GroupConsole",
    "HelpContainer",
  }
selected_console = "PlayersScrollBox"

function on_menu_box_press(section)
  for index = 1, #menu_sections do
    local section_value = menu_sections[index]
    local console_value = menu_consoles[index]
    if section_value == section then
      GUI[console_value]:show()
      if section == "BoxPlayers" then
        sendGMCP("Game.Players.List")
      elseif section == "BoxAbilities" then
        sendGMCP("Char.Guild.Help.List")
      elseif section == "BoxTraining" then
        sendGMCP("Char.Training.List")
      elseif section == "BoxHelp" then
        sendGMCP("Char.Help.List")
      end
      selected_console = console_value
    else
      GUI[console_value]:hide()
    end
  end
end

GUI.BoxMenuButtonCSS =
  CSSMan.new(
    [[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]]
  )
-- The icons will be contained here
GUI.HBoxMenu =
  Geyser.HBox:new(
    {name = "GUI.HBoxMenu", x = "50%", y = 0, width = "50%", height = "5%"}, GUI.Right
  )
-- Add the icons and events
for index = 1, #menu_sections do
  local section_value = menu_sections[index]
  local icon_value = menu_icons[index]
  local tooltip_value = menu_tooltips[index]
  GUI[section_value] =
    Geyser.Label:new(
      {
        name = "GUI." .. section_value,
        message = "<center><font size=\"6\">" .. icon_value .. "</font></center>",
      },
      GUI.HBoxMenu
    )
  GUI[section_value]:setStyleSheet(GUI.BoxMenuButtonCSS:getCSS())
  GUI[section_value]:setClickCallback("on_menu_box_press", section_value)
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
GUI.MenuBox =
  Geyser.Label:new(
    {name = "GUI.MenuBox", x = "50%", y = "5%", width = "50%", height = "89%"}, GUI.Right
  )
setBackgroundColor("GUI.MenuBox", 0, 0, 0)
-- Add the consoles (and two containers)
for index = 1, #menu_consoles do
  local console_value = menu_consoles[index]
  if console_value:find("Console") then
    GUI[console_value] =
      Geyser.MiniConsole:new(
        {
          name = "GUI." .. console_value,
          x = GUI.MenuBox:get_x(),
          y = GUI.MenuBox:get_y(),
          height = GUI.MenuBox:get_height(),
          width = GUI.MenuBox:get_width(),
        }
      )
    setBackgroundColor("GUI." .. console_value, 0, 0, 0)

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
  elseif console_value:find("Container") then
    GUI[console_value] =
      Geyser.Container:new(
        {
          name = "GUI." .. console_value,
          x = GUI.MenuBox:get_x(),
          y = GUI.MenuBox:get_y(),
          height = GUI.MenuBox:get_height(),
          width = GUI.MenuBox:get_width(),
        }
      )
    setBackgroundColor("GUI." .. console_value, 0, 0, 0)
    GUI[console_value]:hide()
  else
    GUI[console_value] =
      Geyser.ScrollBox:new(
        {
          name = "GUI." .. console_value,
          x = GUI.MenuBox:get_x(),
          y = GUI.MenuBox:get_y(),
          height = GUI.MenuBox:get_height() * 4,
          width = GUI.MenuBox:get_width(),
        }
      )
    setBackgroundColor("GUI." .. console_value, 0, 0, 0)
    GUI[console_value]:hide()
  end
end
GUI["HelpContainer"]:hide()
GUI["PlayersScrollBox"]:show()