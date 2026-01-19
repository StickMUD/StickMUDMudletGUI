function CoreGoodbye()
  on_chat_box_press("BoxChatClear")
  -- Clear the content consoles
  if content_consoles then
    for index = 1, #content_consoles - 1 do
      local console_value = content_consoles[index]
      if console_value ~= "MapperConsole" then
        clearWindow("GUI." .. console_value)
      end
    end
  end
  -- Clear the menu consoles
  if menu_consoles then
    for index = 1, #menu_consoles - 1 do
      local console_value = menu_consoles[index]
      clearWindow("GUI." .. console_value)
    end
  end
  -- Kill the tempTimers
  if abilitiesTimers then
    for index = 1, #abilitiesTimers - 1 do
      local timer_value = abilitiesTimers[index]
      killTimer(timer_value)
    end
    abilitiesTimers = {}
  end
  
  -- Clean up abilities panel
  if ClearAllAbilities then
    echo("\n[CoreGoodbye] Calling ClearAllAbilities\n")
    ClearAllAbilities()
  else
    echo("\n[CoreGoodbye] ClearAllAbilities function not found!\n")
  end
end