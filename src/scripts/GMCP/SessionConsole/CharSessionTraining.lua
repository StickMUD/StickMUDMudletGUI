function CharSessionTraining()
	local training_session = gmcp.Char.Session.Training
	local skill_max_length = 0
	local max_count = 0

	table.sort (training_session, 
           function (v1, v2)
             return v1.skill < v2.skill
           end -- function
           )
	
	local t2 = {}

	for k,v in pairs(training_session) do
		local count = 0
		
		if string.len(v.name) > skill_max_length then
			skill_max_length = string.len(v.name)
		end

		for i = 0, string.len(v.skill) do
			if string.sub(v.skill, i, i) == "." then
				count = count + 1
			end
		end
		
		if count > max_count then
			max_count = count
		end
	end
	
	table.insert(t2, "<red>Training"..string.rep(" ", (skill_max_length + max_count - 8)).." Session")	

	for k,v in pairs(training_session) do
	  local count = 0
				
		for i = 0, string.len(v.skill) do
			if string.sub(v.skill, i, i) == "." then
				count = count + 1
			end
		end

		if count == 0 then
			table.insert(t2, "<magenta>"..string.rep(" ", count)..v.name..string.rep(" ", (skill_max_length + max_count - count - string.len(v.name))).." <cyan>"..v.percent)
		elseif count == 1 then 
			table.insert(t2, "<yellow>"..string.rep(" ", count)..v.name..string.rep(" ", (skill_max_length + max_count - count - string.len(v.name))).." <cyan>"..v.percent)
		else
			table.insert(t2, "<gray>"..string.rep(" ", count)..v.name..string.rep(" ", (skill_max_length + max_count - count - string.len(v.name))).." <cyan>"..v.percent)
		end
	end
	
	clearWindow("GUI.SessionConsole")
	--GUI.SessionConsole:setFontSize(14)
	cecho("GUI.SessionConsole", table.concat(t2, "<reset>\n"))
end