-- Handler for Char.Resistances.Remove GMCP package
-- Removes a single resistance from the character's resistance table

function CharResistancesRemove()
    -- Check if GMCP Char.Resistances.Remove data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Resistances or not gmcp.Char.Resistances.Remove then
        return
    end

    local data = gmcp.Char.Resistances.Remove

    -- Remove may arrive as a table ({ name = ... }) or a bare name string
    local name
    if type(data) == "table" then
        name = data.name
    elseif type(data) == "string" then
        name = data
    end

    if not name then
        return
    end

    charResistances = charResistances or {}
    charResistances[name] = nil
end
