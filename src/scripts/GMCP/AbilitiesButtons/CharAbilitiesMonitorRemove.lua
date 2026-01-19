function CharAbilitiesMonitorRemove()
    -- Check if GMCP Char.Abilities.Remove data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities then
        return
    end
    
    local data = gmcp.Char.Abilities.Remove
    if not data then
        return
    end
    
    -- Remove ability from the UI
    if data.name then
        local monitorId = data.monitor and data.monitor.id or nil
        if RemoveAbility then
            RemoveAbility(data.name, monitorId)
        end
    end
end