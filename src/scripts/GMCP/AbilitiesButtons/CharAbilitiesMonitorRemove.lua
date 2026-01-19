function CharAbilitiesMonitorRemove()
    -- Check if GMCP Char.Abilities.Remove data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities then
        echo("\n[AbilityRemove] No GMCP data\n")
        return
    end
    
    local data = gmcp.Char.Abilities.Remove
    if not data then
        echo("\n[AbilityRemove] No Remove data\n")
        return
    end
    
    echo("\n[AbilityRemove] Received: name=" .. tostring(data.name) .. ", id=" .. tostring(data.monitor and data.monitor.id) .. "\n")
    
    -- Remove ability from the UI by monitor ID
    if data.name and data.monitor and data.monitor.id then
        if RemoveAbility then
            echo("[AbilityRemove] Calling RemoveAbility\n")
            RemoveAbility(data.name, data.monitor.id)
        else
            echo("[AbilityRemove] RemoveAbility function not found!\n")
        end
    else
        echo("[AbilityRemove] Missing name or monitor.id\n")
    end
end