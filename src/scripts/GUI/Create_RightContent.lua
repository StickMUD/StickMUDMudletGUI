content_sections = {
    "BoxWieldedWeapons", "BoxWornArmour", "BoxInventory", "BoxRoomInv",
    "BoxMap", "BoxInfo"
}
content_icons = {"⚔️", "🛡", "🎒", "📍", "🗺️", "ℹ️"}
content_tooltips = {"Weapon", "Armour️", "Carry", "Room", "Map", "Info"}
content_consoles = {
    "WieldedWeaponsConsole", "WornArmourConsole", "InventoryConsole",
    "RoomConsole", "MapperConsole", "InfoConsole"
}

-- Function to send GMCP for selected sections
local function sendGMCPForSection(section)
    local itemSections = {
        ["BoxWieldedWeapons"] = true,
        ["BoxWornArmour"] = true,
        ["BoxInventory"] = true
    }
    if itemSections[section] then
        sendGMCP("Char.Items.Inv")
    elseif section == "BoxRoomInv" then
        sendGMCP("Char.Items.Room")
    end
end

function on_content_box_press(section)
    for index = 1, #content_sections do
        local section_value = content_sections[index]
        local console_value = content_consoles[index]
        if section_value == section then
            GUI[console_value]:show()
            sendGMCPForSection(section)
        else
            GUI[console_value]:hide()
        end
    end
end

GUI.BoxContentButtonCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]])

GUI.HBoxContent = Geyser.HBox:new({
    name = "GUI.HBoxContent",
    x = 0,
    y = "45%",
    width = "50%",
    height = "5%"
}, GUI.Right)

-- Helper function to create labels
local function createLabel(section_value, icon_value, tooltip_value)
    GUI[section_value] = Geyser.Label:new({
        name = "GUI." .. section_value,
        message = "<center><font size=\"6\">" .. icon_value ..
            "</font></center>"
    }, GUI.HBoxContent)
    GUI[section_value]:setStyleSheet(GUI.BoxContentButtonCSS:getCSS())
    GUI[section_value]:setClickCallback("on_content_box_press", section_value)
    GUI[section_value]:setOnEnter("enable_tooltip", GUI[section_value],
                                  "<center><b><font size=\"3\">" .. icon_value ..
                                      "</font></b><br>" .. tooltip_value)
    GUI[section_value]:setOnLeave("disable_tooltip", GUI[section_value],
                                  "<center><b><font size=\"6\">" .. icon_value ..
                                      "</font></b>")
end

-- Add the icons and events
for index = 1, #content_sections do
    createLabel(content_sections[index], content_icons[index],
                content_tooltips[index])
end

GUI.ContentBox = Geyser.Label:new({
    name = "GUI.ContentBox",
    x = 0,
    y = "50%",
    width = "50%",
    height = "39%"
}, GUI.Right)
GUI.ContentBox:setStyleSheet(GUI.BoxRightCSS:getCSS())

-- Helper function to initialize consoles
local function initializeConsole(console_value)
    GUI[console_value] = GUI[console_value] or Geyser.MiniConsole:new({
        name = "GUI." .. console_value,
        x = GUI.ContentBox:get_x(),
        y = GUI.ContentBox:get_y(),
        height = GUI.ContentBox:get_height(),
        width = GUI.ContentBox:get_width()
    })
    setBackgroundColor("GUI." .. console_value, 0, 0, 0, 0)
    setFont("GUI." .. console_value, getFont())
    setMiniConsoleFontSize("GUI." .. console_value,
                           content_preferences["GUI." .. console_value].fontSize)
    setFgColor("GUI." .. console_value, 192, 192, 192)
    setBgColor("GUI." .. console_value, 0, 0, 0)
    GUI[console_value]:enableAutoWrap()

    -- Create and style '+' and '-' labels
    createControlLabel(console_value, "Plus", "-50px", "+")
    createControlLabel(console_value, "Minus", "-25px", "-")

    -- Connect labels to font adjustment functions
    GUI[console_value .. "PlusLabel"]:setClickCallback(
        increaseFontSize, GUI[console_value])
    GUI[console_value .. "MinusLabel"]:setClickCallback(
        decreaseFontSize, GUI[console_value])

    GUI[console_value]:hide()
end

-- Add the consoles (except the Mapper)
for index = 1, #content_sections do
    local console_value = content_consoles[index]
    if console_value ~= "MapperConsole" then initializeConsole(console_value) end
end
