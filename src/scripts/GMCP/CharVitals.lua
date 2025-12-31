function round(n)
	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

-- Initialize vitals display to default/empty state
function InitializeVitals()
	if GUI.HitPoints then
		GUI.HitPoints:setValue(0, 100, "<center><b>Hit Points</b></center>")
	end
	if GUI.SpellPoints then
		GUI.SpellPoints:setValue(0, 100, "<center><b>Spell Points</b></center>")
	end
	if GUI.FatiguePoints then
		GUI.FatiguePoints:setValue(0, 100, "<center><b>Fatigue</b></center>")
	end
	if GUI.EnemyHealth then
		GUI.EnemyHealth:setValue(0, 100, "<center><b>Enemy Health</b></center>")
	end
end

function CharVitals()
	-- Check if GMCP Char.Vitals data is available
	if not gmcp or not gmcp.Char or not gmcp.Char.Vitals then
		InitializeVitals()
		return
	end

	local current_hp, max_hp = tonumber(gmcp.Char.Vitals.hp), tonumber(gmcp.Char.Vitals.maxhp)
	local current_sp, max_sp = tonumber(gmcp.Char.Vitals.sp), tonumber(gmcp.Char.Vitals.maxsp)
	local current_fp, max_fp = tonumber(gmcp.Char.Vitals.fp), tonumber(gmcp.Char.Vitals.maxfp)

	-- If any values are nil, show default state
	if not current_hp or not max_hp or not current_sp or not max_sp or not current_fp or not max_fp then
		InitializeVitals()
		return
	end
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

	GUI.FatiguePoints:setValue(current_fp, max_fp, ("<center><b>" ..current_fp.. "/" ..max_fp.. " Fatigue (" ..percent_fp.. ")</b></center>"))	

	-- Handle enemy health (moved from CharStatus - updates every heartbeat during combat)
	local enemy = gmcp.Char.Vitals.enemy or "None"
	local current_enemy_health = gmcp.Char.Vitals.enemyhealth
	local percent_enemy_health

	if enemy == "None" then
		GUI.EnemyHealth:setValue(0, 100, ("<center><b>Enemy Health</b></center>"))
	else
		if current_enemy_health == "mortally wounded" then
			percent_enemy_health = 0
		elseif current_enemy_health == "nearly dead" then
			percent_enemy_health = 4
		elseif current_enemy_health == "in very bad shape" then
			percent_enemy_health = 10
		elseif current_enemy_health == "in bad shape" then
			percent_enemy_health = 20
		elseif current_enemy_health == "not in good shape" then
			percent_enemy_health = 50
		elseif current_enemy_health == "slightly hurt" then
			percent_enemy_health = 95
		elseif current_enemy_health == "in good shape" then
			percent_enemy_health = 100
		end

		GUI.EnemyHealth:setValue(percent_enemy_health, 100, ("<center><b>" ..
			enemy .. " is " .. current_enemy_health .. "</b></center>"))
	end
end