function CharAbilitiesMonitorAdd()
    -- Check if GMCP Char.Abilities.Add data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Add then
        return
    end
    
    local data = gmcp.Char.Abilities.Add
    
    -- Add ability to the UI
    if data.name then
        -- Check if AddAbility function exists
        if AddAbility then
            AddAbility(data.name, data.monitor)
        end
    end
end