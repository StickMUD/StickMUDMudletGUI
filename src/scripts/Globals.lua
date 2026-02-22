GUI = GUI or {}
GUI.IconBackgrounds = GUI.IconBackgrounds or {}

-- Layout presets for different screen sizes
-- Each preset defines: rightPanelWidth + middleWidth = total right side
-- Smaller values = larger main window
GUI.LayoutPresets = {
    ["Compact"] = { rightPanelWidth = 0.30, middleWidth = 0.08, description = "Maximum main window (62%)" },
    ["Normal"]  = { rightPanelWidth = 0.36, middleWidth = 0.10, description = "More main window (54%)" },
    ["Wide"]    = { rightPanelWidth = 0.42, middleWidth = 0.10, description = "Original layout (48%)" }
}

-- Path to layout settings file
layout_settings_file = getMudletHomeDir() .. "/Layout_Settings.lua"

-- Load or set layout settings
layout_settings = layout_settings or {}

if io.exists(layout_settings_file) then
    table.load(layout_settings_file, layout_settings)
    -- Ensure preset exists, default to Normal if not
    if not GUI.LayoutPresets[layout_settings.preset] then
        layout_settings.preset = "Normal"
        table.save(layout_settings_file, layout_settings)
    end
else
    layout_settings.preset = "Normal"
    table.save(layout_settings_file, layout_settings)
end

-- Function to get current layout values
function getLayoutValues()
    local preset = GUI.LayoutPresets[layout_settings.preset] or GUI.LayoutPresets["Normal"]
    return preset
end

-- Helper function to get default console font size
local function getDefaultConsoleFontSize() return getFontSize() - 2 end

-- Helper function to get default console font size
local function getDefaultScrollBoxFontSize() return 6 end

-- Initialize default content preferences using a helper function
default_content_preferences = {
    ["GUI.ChatAllConsole"] = {
        fontSize = getDefaultConsoleFontSize(),
        timestamp = true,
        doublespace = true
    },
    ["GUI.ChatGuildConsole"] = {
        fontSize = getDefaultConsoleFontSize(),
        timestamp = true,
        doublespace = true
    },
    ["GUI.ChatClanConsole"] = {
        fontSize = getDefaultConsoleFontSize(),
        timestamp = true,
        doublespace = true
    },
    ["GUI.ChatTellsConsole"] = {
        fontSize = getDefaultConsoleFontSize(),
        timestamp = true,
        doublespace = true
    },
    ["GUI.ChatLocalConsole"] = {
        fontSize = getDefaultConsoleFontSize(),
        timestamp = true,
        doublespace = true
    },
    ["GUI.WieldedWeaponsConsole"] = {fontSize = getDefaultConsoleFontSize()},
    ["GUI.WornArmourConsole"] = {fontSize = getDefaultConsoleFontSize()},
    ["GUI.InventoryConsole"] = {fontSize = getDefaultConsoleFontSize()},
    ["GUI.RoomConsole"] = {fontSize = getDefaultConsoleFontSize()},
    ["GUI.InfoScrollBox"] = {fontSize = getDefaultConsoleFontSize()},
    ["GUI.AbilitiesConsole"] = {fontSize = getDefaultConsoleFontSize()},
    ["GUI.TrainingScrollBox"] = {fontSize = getDefaultScrollBoxFontSize()},
    ["GUI.SessionScrollBox"] = {fontSize = getDefaultScrollBoxFontSize()},
    ["GUI.EventsScrollBox"] = {fontSize = getDefaultScrollBoxFontSize()},
    ["GUI.GroupScrollBox"] = {fontSize = getDefaultConsoleFontSize()}
}

-- Path to content preferences file
content_preferences_file = getMudletHomeDir() .. "/Content_Preferences.lua"

-- Load or set content preferences
content_preferences = content_preferences or {}

if io.exists(content_preferences_file) then
    table.load(content_preferences_file, content_preferences)

    -- Loop through default content preferences and add any missing keys
    for key, default_values in pairs(default_content_preferences) do
        content_preferences[key] = content_preferences[key] or {}

        for key2, default_value in pairs(default_values) do
            if content_preferences[key][key2] == nil then
                content_preferences[key][key2] = default_value
            end
        end
    end

    -- Save the updated content_preferences if any keys were added
    table.save(content_preferences_file, content_preferences)
else
    content_preferences = default_content_preferences
    table.save(content_preferences_file, content_preferences) -- Only save if loading defaults
end

-- Helper function for capitalization
function firstToUpper(str) return (str:gsub("^%l", string.upper)) end

-- Tooltip functions
function enable_tooltip(whichLabel, message) whichLabel:echo(message) end

function disable_tooltip(whichLabel, message) whichLabel:echo(message) end

-- Helper function to change font size
local function adjustFontSize(contentConsole, adjustment)
    local consoleName = contentConsole.name
    if not consoleName then return end -- Early return if console name is missing

    -- Adjust the font size
    local fontSize = contentConsole:getFontSize() + adjustment
    if fontSize < 1 then fontSize = 1 end
    contentConsole:setFontSize(fontSize)
    contentConsole:resetAutoWrap()

    -- Update preferences and save
    content_preferences[consoleName].fontSize = fontSize
    table.save(content_preferences_file, content_preferences)
end

-- Function to increase font size
function increaseFontSize(contentConsole) adjustFontSize(contentConsole, 1) end

-- Function to decrease font size
function decreaseFontSize(contentConsole) adjustFontSize(contentConsole, -1) end

-- Helper function to create and style labels
function createControlLabel(console_value, labelType, xPos, icon)
    local color = "green"

    if icon == "-" then color = "red" end

    local labelName = console_value .. labelType .. "Label"
    GUI[labelName] = GUI[labelName] or Geyser.Label:new({
        name = "GUI." .. labelName,
        x = xPos,
        y = "0px",
        width = "25px",
        height = "25px",
        message = "<center><font size=\"4\" color=\"" .. color .. "\">" .. icon ..
            "</font></center>"
    }, GUI[console_value])

    if icon == "-" then
        GUI[labelName]:setToolTip("Click to increase font size", "10")
    elseif icon == "+" then
        GUI[labelName]:setToolTip("Click to decrease font size", "10")
    end

    GUI[labelName]:setStyleSheet([[
        background-color: #transparent;
        color: white;
        font-size: 16px;
        text-align: center;
        border: 0px solid #000000;
    ]])
end
-- Function to change layout preset
function setLayoutPreset(presetName)
    if not GUI.LayoutPresets[presetName] then
        cecho("<red>Invalid layout preset: " .. presetName .. "\n")
        return false
    end
    
    layout_settings.preset = presetName
    table.save(layout_settings_file, layout_settings)
    
    -- Update GUI panels if they exist
    if updateLayoutPanels then
        updateLayoutPanels()
    end
    
    -- Update borders
    if updateBorders then
        updateBorders()
    end
    
    cecho("<green>Layout changed to: " .. presetName .. " - " .. GUI.LayoutPresets[presetName].description .. "\n")
    return true
end

-- Function to cycle to next layout preset
function cycleLayoutPreset()
    local presetOrder = {"Compact", "Normal", "Wide"}
    local currentIndex = 1
    
    for i, name in ipairs(presetOrder) do
        if name == layout_settings.preset then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = (currentIndex % #presetOrder) + 1
    setLayoutPreset(presetOrder[nextIndex])
end