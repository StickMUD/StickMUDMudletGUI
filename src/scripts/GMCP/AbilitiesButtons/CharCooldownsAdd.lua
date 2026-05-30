function CharCooldownsAdd()
    -- Check if GMCP Char.Cooldowns.Add data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Cooldowns or not gmcp.Char.Cooldowns.Add then
        return
    end
    
    local data = gmcp.Char.Cooldowns.Add
    
    -- An empty Add (no name) is the reset signal that precedes a List reply:
    -- clear all tracked cooldowns so the repopulate has no stale/duplicate rows.
    if not data.name then
        if ClearAllCooldowns then
            ClearAllCooldowns()
        end
        return
    end
    
    -- Populated payload: add or refresh the cooldown row
    if data.cooldown and AddCooldown then
        AddCooldown(data.name, data.cooldown)
    end
end
