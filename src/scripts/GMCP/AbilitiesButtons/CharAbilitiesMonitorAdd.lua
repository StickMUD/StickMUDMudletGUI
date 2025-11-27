function CharAbilitiesMonitorAdd()
    -- Check if GMCP Char.Abilities.Add data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Add then
        return
    end
    
    local char_abilities_add = gmcp.Char.Abilities.Add
  
    --for index = 19, 2, -1 do
    --index = 19;
    --gauge_name = "AbilityGauge" .. index;
      --GUI[gauge_name]:setValue(100, 100, ("<span style = 'color: black'><center><b>" ..firstToUpper(char_abilities_add.name).. "</b></center></span>"))	
    --GUI[gauge_name]:show()
    --end
  
    if char_abilities_add.monitor and char_abilities_add.monitor.expires ~= nil and char_abilities_add.monitor.expires > 0 then
      abilitiesTimers[char_abilities_add.monitor.id] =
        tempTimer(
          char_abilities_add.monitor.expires,
          function()
          end
        )
    end
  end