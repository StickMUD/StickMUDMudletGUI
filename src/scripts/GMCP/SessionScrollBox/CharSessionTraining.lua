-- Define the CSS for the session training list display
GUI.CharSessionTrainingCSS = CSSMan.new([[
	qproperty-wordWrap: true;
    qproperty-alignment: 'AlignTop';
]])

function CharSessionTraining()
    local training_session = gmcp.Char.Session.Training
    local skill_max_length = 0
    local max_count = 0

    table.sort(training_session, function(v1, v2) return v1.skill < v2.skill end)

    local sessionList = "<table width=\"100%\">"

    -- Calculate maximum lengths and counts
    for k, v in pairs(training_session) do
        local count = 0

        if string.len(v.name) > skill_max_length then
            skill_max_length = string.len(v.name)
        end

        for i = 0, string.len(v.skill) do
            if string.sub(v.skill, i, i) == "." then
                count = count + 1
            end
        end

        if count > max_count then max_count = count end
    end

    sessionList = sessionList ..
                      "<tr><td><font size=\"3\" color=\"red\">Training Session</font></td></tr>"

    -- Construct the session training list
    for k, v in pairs(training_session) do
        local count = 0

        for i = 0, string.len(v.skill) do
            if string.sub(v.skill, i, i) == "." then
                count = count + 1
            end
        end

        local color = "<font size=\"3\" color=\"gray\">"
        if count == 0 then
            color = "<font size=\"3\" color=\"magenta\">"
        elseif count == 1 then
            color = "<font size=\"3\" color=\"yellow\">"
        end

        sessionList = sessionList .. "<tr><td>" .. color ..
                          string.rep("&nbsp;", count) .. v.name ..
                          string.rep("&nbsp;",
                                     (skill_max_length + max_count - count -
                                         string.len(v.name))) .. "</font></td>"
        sessionList = sessionList .. "<td>" .. color ..
                          "<font size=\"3\" color=\"cyan\">" .. v.percent ..
                          "</font></td></tr>"
    end

    sessionList = sessionList .. "</table>"

    -- Create the ScrollBox and populate it with the session training list
    GUI.CharSessionTrainingLabel = Geyser.Label:new({
        name = "GUI.CharSessionTrainingLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "200%"
    }, GUI.SessionScrollBox)
    GUI.CharSessionTrainingLabel:setStyleSheet(
        GUI.CharSessionTrainingCSS:getCSS())
    setBackgroundColor("GUI.CharSessionTrainingLabel", 0, 0, 0)
    GUI.CharSessionTrainingLabel:echo(sessionList)
end
