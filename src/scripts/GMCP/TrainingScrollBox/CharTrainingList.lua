-- Initialize font size for the training list
local currentFontSize = content_preferences["GUI.TrainingScrollBox"].fontSize
local minFontSize = 1 -- Minimum allowed font size

-- Define the CSS for the training list display with dynamic font size
-- Dynamically sets the font size based on the provided `fontSize` parameter
function getCharTrainingListCSS(fontSize)
    return CSSMan.new([[
        qproperty-wordWrap: true;
        qproperty-alignment: 'AlignTop';
        font-size: ]] .. fontSize .. [[px;
    ]])
end

-- Function to adjust the font size of the training list
-- Rebuilds the training list to reflect the new font size
-- @param adjustment: The value to increase/decrease the font size by
function adjustFontSizeTrainingList(adjustment)
    currentFontSize = currentFontSize + adjustment
    if currentFontSize < minFontSize then currentFontSize = minFontSize end -- Ensure font size doesn't drop below 1
    -- Update preferences and save
    content_preferences["GUI.TrainingScrollBox"].fontSize = currentFontSize
    table.save(content_preferences_file, content_preferences)
    CharTrainingList() -- Rebuild the training list with the updated font size
end

-- Creates the font adjustment panel with "+" and "-" buttons to change the font size
function createFontAdjustmentPanel()
    -- Background label for the adjustment panel
    GUI.TrainingBackgroundLabel = Geyser.Label:new({
        name = "GUI.TrainingBackgroundLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.TrainingScrollBox)

    -- Set the background color for the panel
    GUI.TrainingBackgroundLabel:setStyleSheet([[
    	QLabel{
  			background-color: rgba(0,0,0,255);
  		}
	]])

    -- Main container (HBox) to hold the "+" and "-" buttons
    GUI.TrainingHBox = Geyser.Label:new({
        name = "GUI.TrainingHBox",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.TrainingBackgroundLabel)

    -- Left filler to center the "+" and "-" buttons
    GUI.TrainingLeftFillerLabel = Geyser.Label:new({
        name = "GUI.TrainingLeftFillerLabel",
        x = 0,
        y = 0,
        width = "75%",
        height = "25px"
    }, GUI.TrainingHBox)

    -- Empty left filler area
    GUI.TrainingLeftFillerLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 0px;
        text-align: left;
    ]])

    -- Label for the "+" button to increase font size
    GUI.PlusLabel = Geyser.Label:new({
        name = "GUI.PlusLabel",
        x = "75%",
        y = 0,
        width = "11%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"green\">+</font></center>" -- Display a green "+" symbol
    }, GUI.TrainingHBox)

    -- Attach the click callback to increase the font size when "+" is clicked
    GUI.PlusLabel:setClickCallback(function() adjustFontSizeTrainingList(1) end)

    -- Style the "+" button
    GUI.PlusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])

    -- Label for the "-" button to decrease font size
    GUI.MinusLabel = Geyser.Label:new({
        name = "GUI.MinusLabel",
        x = "85%",
        y = 0,
        width = "10%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"red\">-</font></center>" -- Display a red "-" symbol
    }, GUI.TrainingHBox)

    -- Attach the click callback to decrease the font size when "-" is clicked
    GUI.MinusLabel:setClickCallback(
        function() adjustFontSizeTrainingList(-1) end)

    -- Style the "-" button
    GUI.MinusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])

    -- Right filler to keep the layout aligned
    GUI.TrainingRightFillerLabel = Geyser.Label:new({
        name = "GUI.TrainingRightFillerLabel",
        x = "95%",
        y = 0,
        width = "5%",
        height = "25px"
    }, GUI.TrainingHBox)

    -- Empty right filler area
    GUI.TrainingRightFillerLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 0px;
        text-align: center;
    ]])
end

-- Add a global variable to track the selected filter
local activeFilter = "Yes"

-- Create the filter drop-down
function createActiveFilterDropdown()
    -- Label for the "Active:" filter
    GUI.ActiveFilterLabel = Geyser.Label:new({
        name = "GUI.ActiveFilterLabel",
        x = 0,
        y = "0%",
        width = "10%",
        height = "25px",
        message = "<font size=\"4\" color=\"white\">Active:</font>"
    }, GUI.TrainingScrollBox)

    GUI.ActiveFilterLabel:setStyleSheet([[
        QLabel {
            background-color: rgba(0, 0, 0, 255);
            text-align: center;
        }
    ]])

    -- Drop-down for the filter
    GUI.ActiveFilterDropdown = Geyser.Label:new({
        name = "GUI.ActiveFilterDropdown",
        x = "10%",
        y = "0%",
        width = "15%",
        height = "25px",
        message = [[
            <select id="activeFilterSelect">
                <option value="Yes" selected>Yes</option>
                <option value="No">No</option>
            </select>
        ]]
    }, GUI.TrainingScrollBox)

    GUI.ActiveFilterDropdown:setClickCallback(function()
        local selectedValue = getWebViewInput("activeFilterSelect")
        if selectedValue then
            activeFilter = selectedValue
            CharTrainingList() -- Refresh the training list based on the filter
        end
    end)

    GUI.ActiveFilterDropdown:setStyleSheet([[
        QLabel {
            background-color: rgba(0, 0, 0, 255);
            border: 1px solid white;
        }
    ]])
end

-- Modify CharTrainingList to filter based on the active filter
function CharTrainingList()
    local training_total = nil
    local session_training = nil

    if gmcp.Char and gmcp.Char.Training and gmcp.Char.Training.List then
        training_total = gmcp.Char.Training.List
    end

    if gmcp.Char and gmcp.Char.Session and gmcp.Char.Session.Training then
        session_training = gmcp.Char.Session.Training
    end

    local skill_max_length = 0
    local max_count = 0
    local sessionSkills = {}

    if session_training then
        for _, v in pairs(session_training) do
            sessionSkills[v.skill] = true
        end
    end

    local trainingList = "<table width=\"100%\"><tr><td><font size=\"" ..
                             currentFontSize ..
                             "\" color=\"red\">TRAINING</font></td><td><font size=\"" ..
                             currentFontSize ..
                             "\" color=\"red\">RANK</font></td></tr>"

    if training_total then
        -- Filter training_total based on activeFilter
        local filteredTraining = {}
        for _, v in ipairs(training_total) do
            if activeFilter == "No" or v.active == "Yes" then
                table.insert(filteredTraining, v)
            end
        end

        -- Sort and display filtered training
        table.sort(filteredTraining,
                   function(v1, v2) return v1.skill < v2.skill end)

        for _, v in ipairs(filteredTraining) do
            local count = 0
            for i = 0, string.len(v.skill) do
                if string.sub(v.skill, i, i) == "." then
                    count = count + 1
                end
            end

            local session = ""
            if sessionSkills[v.skill] then
                session = "<font size=\"" .. currentFontSize ..
                              "\" color=\"white\">*</font>"
            end

            local color = "<font size=\"" .. currentFontSize ..
                              "\" color=\"gray\">"

            if count == 0 then
                color = "<font size=\"" .. currentFontSize ..
                            "\" color=\"magenta\">"
            elseif count == 1 then
                color = "<font size=\"" .. currentFontSize ..
                            "\" color=\"yellow\">"
            end

            trainingList = trainingList .. "<tr><td>" .. color ..
                               string.rep("&nbsp;", count) .. v.name .. session ..
                               string.rep("&nbsp;",
                                          (skill_max_length + max_count - count -
                                              string.len(v.name))) ..
                               "</font></td>"
            trainingList = trainingList .. "<td>" .. color .. v.rank ..
                               "</font> <font size=\"" .. currentFontSize ..
                               "\" color=\"cyan\">" .. v.percent ..
                               "</font></td></tr>"
        end
    end

    trainingList =
        trainingList .. "</table><p><font size=\"" .. currentFontSize ..
            "\" color=\"white\">*Trained this session</font></p>"

    if GUI.CharTrainingListLabel then
        GUI.CharTrainingListLabel:echo(trainingList)
    else
        GUI.CharTrainingListLabel = Geyser.Label:new({
            name = "GUI.CharTrainingListLabel",
            x = 0,
            y = "25px",
            width = "100%",
            height = "400%"
        }, GUI.TrainingScrollBox)
    end

    GUI.CharTrainingListLabel:setStyleSheet(
        getCharTrainingListCSS(currentFontSize):getCSS())
    setBackgroundColor("GUI.CharTrainingListLabel", 0, 0, 0)
    GUI.CharTrainingListLabel:echo(trainingList)
end

-- Initialize the drop-down and the training list
createActiveFilterDropdown()
CharTrainingList()