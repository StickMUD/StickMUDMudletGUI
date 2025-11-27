function CharAbilitiesMonitorWarn()
    -- Check if GMCP Char.Abilities.Update data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Update then
        return
    end
    
    local char_abilities_update = gmcp.Char.Abilities.Update
  
    --for index = 19, 2, -1 do
    --index = 19;
    --gauge_name = "AbilityGauge" .. index;
      --GUI[gauge_name]:setValue(100, 100, ("<span style = 'color: black'><center><b>" ..firstToUpper(char_abilities_update.name).. "</b></center></span>"))	
    --GUI[gauge_name].back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
    --GUI.GaugeFrontCSS:set("background-color","gray")
    --GUI[gauge_name].front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
    --GUI[gauge_name]:flash()
    --end
  
    if char_abilities_update.monitor and char_abilities_update.monitor.warn ~= nil and char_abilities_update.monitor.warn == 1 then
    end
  end