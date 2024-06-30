function CoreGoodbye()
  on_chat_box_press("ChatClearConsole")
  -- Clear the content consoles
  for index = 1, #content_consoles - 1 do
    local console_value = content_consoles[index]
    if console_value ~= "MapperConsole" then
      clearWindow("GUI." .. console_value)
    end
  end
  -- Clear the menu consoles
  for index = 1, #menu_consoles - 1 do
    local console_value = menu_consoles[index]
    clearWindow("GUI." .. console_value)
  end
  -- Kill the tempTimers
  for index = 1, #abilitiesTimers - 1 do
    local timer_value = abilitiesTimers[index]
    killTimer(timer_value)
  end
  abilitiesTimers = {}
end