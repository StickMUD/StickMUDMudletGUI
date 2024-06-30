function CharAbilitiesMonitorAdd()
  local char_abilities_update = gmcp.Char.Abilities.Update
  if char_abilities_update.monitor.expires ~= nil and char_abilities_update.monitor.expires > 0 then
    abilitiesTimers[char_abilities_update.monitor.id] =
      tempTimer(
        char_abilities_update.monitor.expires,
        function()
        end
      )
  end
end