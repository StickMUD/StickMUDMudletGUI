function Group()
    local group_name
    local group_leader
    local group_exp
    local group_members
    local percent_hp, percent_sp, percent_fp
    local buffer
    local t2 = {}

    if gmcp.Group ~= "" then
        group_name = gmcp.Group.groupname
        group_leader = gmcp.Group.leader
        group_exp = gmcp.Group.exp
        group_members = gmcp.Group.members
        -- function
        table.sort(group_members, function(v1, v2)
            return v1.name < v2.name
        end)
        for k, v in pairs(group_members) do
            percent_hp = round(tonumber(v.info.hp / v.info.maxhp * 10))
            percent_sp = round(tonumber(v.info.sp / v.info.maxsp * 10))
            percent_fp = round(tonumber(v.info.fp / v.info.maxfp * 10))

            buffer = "<yellow>" .. firstToUpper(v.name) .. "<reset>"

            if (v.info.here ~= "Yes") then
                buffer = buffer .. " <red>(Not Here)<reset>"
            else
                buffer = buffer .. " <gray>(Here)<reset>"
            end

            if (group_leader ~= v.name) then
                buffer = buffer .. " \n\n"
            else
                buffer = buffer .. " <magenta>(Leader)<reset>\n\n"
            end

            if percent_hp >= 5 then
                buffer = buffer .. " Hit     ️<cyan:red>" ..
                             string.rep("|", percent_hp) ..
                             string.rep(".", 10 - percent_hp) .. "<reset>\n\n"
            else
                buffer = buffer .. " Hit     ️<black:red>" ..
                             string.rep("|", percent_hp) ..
                             string.rep(".", 10 - percent_hp) .. "<reset>\n\n"
            end
            if percent_sp >= 5 then
                buffer = buffer .. " Spell   ️<cyan:blue>" ..
                             string.rep("|", percent_sp) ..
                             string.rep(".", 10 - percent_sp) .. "<reset>\n\n"
            else
                buffer = buffer .. " Spell   ️<black:blue>" ..
                             string.rep("|", percent_sp) ..
                             string.rep(".", 10 - percent_sp) .. "<reset>\n\n"
            end
            if percent_fp >= 5 then
                buffer = buffer .. " Fatigue ️<black:green>" ..
                             string.rep("|", percent_fp) ..
                             string.rep(".", 10 - percent_fp) .. "<reset>\n"
            else
                buffer = buffer .. " Fatigue <blue:green>" ..
                             string.rep("|", percent_fp) ..
                             string.rep(".", 10 - percent_fp) .. "<reset>\n"
            end

            table.insert(t2, buffer)
        end
    end

    clearWindow("GUI.GroupConsole")
    setFont("GUI.GroupConsole", getFont())
    setMiniConsoleFontSize("GUI.GroupConsole", getFontSize() - 2)

    cecho("GUI.GroupConsole", table.concat(t2, "<reset>\n"))
end
