-- Initialize font size for the session training list
local sessionCurrentFontSize = content_preferences["GUI.SessionScrollBox"]
                                   .fontSize
local sessionMinFontSize = 1 -- Minimum allowed font size

-- Define the CSS for the session training list display with dynamic font size
-- Dynamically sets the font size based on the provided `fontSize` parameter
function getSessionTrainingCSS(fontSize)
    return CSSMan.new([[
        qproperty-wordWrap: true;
        qproperty-alignment: 'AlignTop';
        font-size: ]] .. fontSize .. [[px;
    ]])
end

-- Function to adjust the font size of the session training list
-- Rebuilds the session training list to reflect the new font size
-- @param adjustment: The value to increase/decrease the font size by
function adjustFontSizeSessionList(adjustment)
    sessionCurrentFontSize = sessionCurrentFontSize + adjustment
    if sessionCurrentFontSize < sessionMinFontSize then
        sessionCurrentFontSize = sessionMinFontSize
    end -- Ensure font size doesn't drop below 1
    -- Update preferences and save
    content_preferences["GUI.SessionScrollBox"].fontSize =
        sessionCurrentFontSize
    table.save(content_preferences_file, content_preferences)
    CharSessionTraining() -- Rebuild the session training list with the updated font size
end

-- Creates the font adjustment panel with "+" and "-" buttons to change the font size
function createFontAdjustmentPanelForSession()
    -- Background label for the adjustment panel
    GUI.SessionTrainingBackgroundLabel = Geyser.Label:new({
        name = "GUI.SessionTrainingBackgroundLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.SessionScrollBox)

    -- Set the background color for the panel
    GUI.SessionTrainingBackgroundLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(0,0,0,255);
        }
    ]])

    -- Main container (HBox) to hold the "+" and "-" buttons
    GUI.SessionTrainingHBox = Geyser.Label:new({
        name = "GUI.SessionTrainingHBox",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.SessionTrainingBackgroundLabel)

    -- Left filler to center the "+" and "-" buttons
    GUI.SessionTrainingLeftFillerLabel = Geyser.Label:new({
        name = "GUI.SessionTrainingLeftFillerLabel",
        x = 0,
        y = 0,
        width = "75%",
        height = "25px"
    }, GUI.SessionTrainingHBox)

    -- Empty left filler area
    GUI.SessionTrainingLeftFillerLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 0px;
        text-align: left;
    ]])

    -- Label for the "+" button to increase font size
    GUI.SessionPlusLabel = Geyser.Label:new({
        name = "GUI.SessionPlusLabel",
        x = "75%",
        y = 0,
        width = "11%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"green\">+</font></center>" -- Display a green "+" symbol
    }, GUI.SessionTrainingHBox)

    -- Attach the click callback to increase the font size when "+" is clicked
    GUI.SessionPlusLabel:setClickCallback(function()
        adjustFontSizeSessionList(1)
    end)

    -- Style the "+" button
    GUI.SessionPlusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])

    -- Label for the "-" button to decrease font size
    GUI.SessionMinusLabel = Geyser.Label:new({
        name = "GUI.SessionMinusLabel",
        x = "85%",
        y = 0,
        width = "10%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"red\">-</font></center>" -- Display a red "-" symbol
    }, GUI.SessionTrainingHBox)

    -- Attach the click callback to decrease the font size when "-" is clicked
    GUI.SessionMinusLabel:setClickCallback(function()
        adjustFontSizeSessionList(-1)
    end)

    -- Style the "-" button
    GUI.SessionMinusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])

    -- Right filler to keep the layout aligned
    GUI.SessionTrainingRightFillerLabel = Geyser.Label:new({
        name = "GUI.SessionTrainingRightFillerLabel",
        x = "95%",
        y = 0,
        width = "5%",
        height = "25px"
    }, GUI.SessionTrainingHBox)

    -- Empty right filler area
    GUI.SessionTrainingRightFillerLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-color: #31363b;
        border-width: 0px;
        text-align: center;
    ]])
end

-- Function to display the character session training list
function CharSessionTraining()
    local training_session = nil

    -- Check if gmcp.Char and gmcp.Char.Session and gmcp.Char.Session.Training exist
    if gmcp.Char and gmcp.Char.Session and gmcp.Char.Session.Training then
        training_session = gmcp.Char.Session.Training
    end

    local skill_max_length = 0
    local max_count = 0

    if training_session then
        table.sort(training_session,
                   function(v1, v2) return v1.skill < v2.skill end)
    end

    local sessionList = "<table width=\"100%\">"

    -- Calculate maximum lengths and counts for alignment
    if training_session then
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
    end

    sessionList = sessionList .. "<tr><td><font size=\"" ..
                      sessionCurrentFontSize ..
                      "\" color=\"red\">TRAINING</td><td><font size=\"" ..
                      sessionCurrentFontSize ..
                      "\" color=\"red\">SESSION</font></td></tr>"

    -- Construct the session training list
    if training_session then
        for k, v in pairs(training_session) do
            local count = 0

            for i = 0, string.len(v.skill) do
                if string.sub(v.skill, i, i) == "." then
                    count = count + 1
                end
            end

            local color = "<font size=\"" .. sessionCurrentFontSize ..
                              "\" color=\"gray\">"
            if count == 0 then
                color = "<font size=\"" .. sessionCurrentFontSize ..
                            "\" color=\"magenta\">"
            elseif count == 1 then
                color = "<font size=\"" .. sessionCurrentFontSize ..
                            "\" color=\"yellow\">"
            end

            sessionList = sessionList .. "<tr><td>" .. color ..
                              string.rep("&nbsp;", count) .. v.name ..
                              string.rep("&nbsp;",
                                         (skill_max_length + max_count - count -
                                             string.len(v.name))) ..
                              "</font></td>"
            sessionList = sessionList .. "<td>" .. color .. "<font size=\"" ..
                              sessionCurrentFontSize .. "\" color=\"cyan\">" ..
                              v.percent .. "</font></td></tr>"
        end
    end

    sessionList = sessionList .. "</table>"

    -- Create the ScrollBox and populate it with the session training list
    GUI.CharSessionTrainingLabel = Geyser.Label:new({
        name = "GUI.CharSessionTrainingLabel",
        x = 0,
        y = "25px", -- Adjust y position to accommodate the adjustment panel
        width = "100%",
        height = "400%"
    }, GUI.SessionScrollBox)

    -- Set the CSS with the current font size and update the background
    GUI.CharSessionTrainingLabel:setStyleSheet(
        getSessionTrainingCSS(sessionCurrentFontSize):getCSS())
    setBackgroundColor("GUI.CharSessionTrainingLabel", 0, 0, 0)
    GUI.CharSessionTrainingLabel:echo(sessionList)
end

-- Create the font adjustment panel and the session training list
createFontAdjustmentPanelForSession()
CharSessionTraining()
