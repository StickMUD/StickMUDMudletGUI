function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function enable_tooltip(whichLabel, message)
	whichLabel:echo(message)
end

function disable_tooltip(whichLabel, message)
	whichLabel:echo(message)
end

GUI = GUI or {}