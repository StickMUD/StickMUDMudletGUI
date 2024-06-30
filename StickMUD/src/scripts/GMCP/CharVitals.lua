function round(n)
	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function CharVitals()
	local current_hp, max_hp = tonumber(gmcp.Char.Vitals.hp), tonumber(gmcp.Char.Vitals.maxhp)
	local current_sp, max_sp = tonumber(gmcp.Char.Vitals.sp), tonumber(gmcp.Char.Vitals.maxsp)
	local current_fp, max_fp = tonumber(gmcp.Char.Vitals.fp), tonumber(gmcp.Char.Vitals.maxfp)
	local percent_hp = round(tonumber(current_hp / max_hp * 100))
	local percent_sp = round(tonumber(current_sp / max_sp * 100))
	local percent_fp = round(tonumber(current_fp / max_fp * 100))

	percent_hp = percent_hp.."%"
	if string.cut(percent_hp, 1) == "-" then percent_hp = "0%" end
	if current_hp > max_hp then current_hp = max_hp end
  
	GUI.HitPoints:setValue(current_hp, max_hp, ("<center><b>" ..current_hp.. "/" ..max_hp.. " Hit (" ..percent_hp.. ")</b></center>"))	
	
	percent_sp = percent_sp.."%"
	if string.cut(percent_sp, 1) == "-" then percent_sp = "0%" end
	if current_sp > max_sp then current_sp = max_sp end

	GUI.SpellPoints:setValue(current_sp, max_sp, ("<center><b>" ..current_sp.. "/" ..max_sp.. " Spell (" ..percent_sp.. ")</b></center>"))	

	percent_fp = percent_fp.."%"
	if string.cut(percent_fp, 1) == "-" then percent_fp = "0%" end
	if current_fp > max_fp then current_fp = max_fp end

	GUI.FatiguePoints:setValue(current_fp, max_fp, ("<span style = 'color: black'><center><b>" ..current_fp.. "/" ..max_fp.. " Fatigue (" ..percent_fp.. ")</b></center></span>"))	
end