function CharAbilitiesMonitorAdd()
    -- Check if GMCP Char.Abilities.Add data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Abilities or not gmcp.Char.Abilities.Add then
        return
    end
    
    local char_abilities_add = gmcp.Char.Abilities.Add
    
    -- Add ability to the UI
    if char_abilities_add.name then
        AddAbility(char_abilities_add.name, char_abilities_add.monitor)
    end
end