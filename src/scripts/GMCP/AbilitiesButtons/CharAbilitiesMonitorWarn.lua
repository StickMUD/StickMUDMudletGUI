function CharAbilitiesMonitorWarn()
    -- Check if GMCP Char.Abilities.Update data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Update then
        return
    end
    
    local data = gmcp.Char.Abilities.Update
    
    -- Update ability warning state in the UI (by monitor ID)
    if data.name and data.monitor and data.monitor.id and UpdateAbilityWarning then
        local monitorId = data.monitor.id
        local warn = data.monitor.warn or 0
        UpdateAbilityWarning(data.name, monitorId, warn)
    end
end