-- Handler for Char.Resistances.Add GMCP package
-- Adds (or updates) a single resistance in the character's resistance table

function CharResistancesAdd()
    -- Check if GMCP Char.Resistances.Add data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Resistances or not gmcp.Char.Resistances.Add then
        return
    end

    local data = gmcp.Char.Resistances.Add
    if type(data) ~= "table" or not data.name then
        return
    end

    charResistances = charResistances or {}
    charResistances[data.name] = { name = data.name, desc = data.desc }
end
