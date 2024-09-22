GUI = GUI or {}

-- Helper function to get default font size
local function getDefaultFontSize() return getFontSize() - 2 end

-- Initialize default content preferences using a helper function
default_content_preferences = {
    ["GUI.ChatAllConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.ChatGuildConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.ChatClanConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.ChatTellsConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.ChatLocalConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.WieldedWeaponsConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.WornArmourConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.InventoryConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.RoomConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.InfoConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.AbilitiesConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.GroupConsole"] = {fontSize = getDefaultFontSize()},
    ["GUI.HelpConsole"] = {fontSize = getDefaultFontSize()}
}

-- Path to content preferences file
content_preferences_file = getMudletHomeDir() .. "/Content_Preferences.lua"

-- Load or set content preferences
content_preferences = content_preferences or {}
if io.exists(content_preferences_file) then
    table.load(content_preferences_file, content_preferences)

    -- Loop through default content preferences and add any missing keys
    for key, value in pairs(default_content_preferences) do
        if not content_preferences[key] then
            content_preferences[key] = value
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
function createControlLabel(console_value, labelType, xPos, message)
    local labelName = "GUI." .. console_value .. labelType .. "Label"
    GUI[labelName] = GUI[labelName] or Geyser.Label:new({
        name = labelName,
        x = xPos,
        y = "0px",
        width = "25px",
        height = "25px",
        message = "<center>" .. message .. "</center>"
    }, GUI[console_value])
    GUI[labelName]:setStyleSheet([[
        background-color: #transparent;
        color: white;
        font-size: 16px;
        text-align: center;
        border: 0px solid #000000;
    ]])
end
