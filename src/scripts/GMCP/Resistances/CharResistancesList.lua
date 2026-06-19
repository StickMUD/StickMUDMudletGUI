-- Handler for Char.Resistances.List GMCP package
-- Replaces the full set of the character's known resistances

-- Global table of the character's resistances, keyed by resistance name.
-- Each entry is { name = <string>, desc = <string> }
charResistances = charResistances or {}

function CharResistancesList()
    -- Check if GMCP Char.Resistances.List data is available
    if not gmcp or not gmcp.Char or not gmcp.Char.Resistances or not gmcp.Char.Resistances.List then
        return
    end

    local list = gmcp.Char.Resistances.List
    if type(list) ~= "table" then
        return
    end

    -- Rebuild the table from scratch since List is the authoritative set
    charResistances = {}
    for _, resist in ipairs(list) do
        if resist.name then
            charResistances[resist.name] = { name = resist.name, desc = resist.desc }
        end
    end
end
