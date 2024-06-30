function CharAbilitiesMonitorRemove()
  local char_abilities_remove = gmcp.Char.Abilities.Remove
  if
    char_abilities_remove.monitor.id ~= nil and
    abilitiesTimers[char_abilities_remove.monitor.id] ~= nil
  then
    killTimer(abilitiesTimers[char_abilities_remove.monitor.id])
    abilitiesTimers[char_abilities_remove.monitor.id] = nil;
  end
end