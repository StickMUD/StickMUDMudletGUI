function CharAbilitiesMonitorRemove()
    -- Check if GMCP Char.Abilities.Remove data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Remove then
        return
    end
    
    local data = gmcp.Char.Abilities.Remove
    
    -- Remove ability from the UI
    if data.name and RemoveAbility then
        local monitorId = data.monitor and data.monitor.id or nil
        RemoveAbility(data.name, monitorId)
    end
end