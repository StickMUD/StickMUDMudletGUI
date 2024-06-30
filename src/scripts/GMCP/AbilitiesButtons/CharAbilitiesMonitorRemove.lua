function CharAbilitiesMonitorRemove()
    local char_abilities_remove = gmcp.Char.Abilities.Remove
  
    --for index = 19, 2, -1 do
    --index = 19;
    --gauge_name = "AbilityGauge" .. index;
      --GUI[gauge_name]:setValue(100, 100, ("<span style = 'color: black'><center><b>" ..firstToUpper(char_abilities_remove.name).. "</b></center></span>"))	
          --GUI[gauge_name].back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
    --GUI.GaugeFrontCSS:set("background-color","white")
    --GUI[gauge_name].front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
    --GUI[gauge_name]:hide()
    --end
  
    if
      char_abilities_remove.monitor.id ~= nil and
      abilitiesTimers[char_abilities_remove.monitor.id] ~= nil
    then
      killTimer(abilitiesTimers[char_abilities_remove.monitor.id])
      abilitiesTimers[char_abilities_remove.monitor.id] = nil;
    end
  end