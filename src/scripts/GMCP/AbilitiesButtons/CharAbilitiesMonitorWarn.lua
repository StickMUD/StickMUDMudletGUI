function CharAbilitiesMonitorWarn()
    -- Check if GMCP Char.Abilities.Update data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Update then
        return
    end
    
    local char_abilities_update = gmcp.Char.Abilities.Update
    
    -- Update ability warning state in the UI
    if char_abilities_update.name and char_abilities_update.monitor then
        local warn = char_abilities_update.monitor.warn or 0
        UpdateAbilityWarning(char_abilities_update.name, warn)
    end
end