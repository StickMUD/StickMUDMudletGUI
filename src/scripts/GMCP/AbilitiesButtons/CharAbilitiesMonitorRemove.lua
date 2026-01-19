function CharAbilitiesMonitorRemove()
    -- Check if GMCP Char.Abilities.Remove data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Remove then
        return
    end
    
    local char_abilities_remove = gmcp.Char.Abilities.Remove
    
    -- Remove ability from the UI
    if char_abilities_remove.name then
        local monitorId = char_abilities_remove.monitor and char_abilities_remove.monitor.id or nil
        RemoveAbility(char_abilities_remove.name, monitorId)
    end
end