nextContentBox = "BoxMap";

-- Content items data structure
local content_items = {
    { section = "BoxWieldedWeapons", icon = "044-swords.png", tooltip = "Weapon", console = "WieldedWeaponsConsole" },
    { section = "BoxWornArmour", icon = "045-knight-1.png", tooltip = "Armour️", console = "WornArmourConsole" },
    { section = "BoxInventory", icon = "040-school-bag.png", tooltip = "Carry", console = "InventoryConsole" },
    { section = "BoxRoomInv", icon = "041-location.png", tooltip = "Room", console = "RoomConsole" },
    { section = "BoxMap", icon = "042-treasure-map.png", tooltip = "Map", console = "MapperConsole" },
    { section = "BoxInfo", icon = "043-informative.png", tooltip = "Info", console = "InfoConsole" }
}

-- Function to send GMCP for selected sections
local function sendGMCPForSection(section)
    local itemSections = { BoxWieldedWeapons = true, BoxWornArmour = true, BoxInventory = true }
    if itemSections[section] then
        sendGMCP("Char.Items.Inv")
    elseif section == "BoxRoomInv" then
        sendGMCP("Char.Items.Room")
    end
end

function on_content_box_press(section)
    for _, item in ipairs(content_items) do
        if item.section == section then
            GUI[item.console]:show()
            sendGMCPForSection(section)
            nextContentBox = section
        else
            GUI[item.console]:hide()
        end
    end
end

-- CSS for content buttons
GUI.BoxContentButtonCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]])

-- Main container for content buttons
GUI.HBoxContent = Geyser.HBox:new({
    name = "GUI.HBoxContent",
    x = 0,
    y = "45%",
    width = "50%",
    height = "5%"
}, GUI.Right)

-- Function to create labels for content items
local function createLabel(item)
    local icon_path = getMudletHomeDir() .. "/StickMUD/" .. item.icon
    GUI[item.section] = Geyser.Label:new({
        name = "GUI." .. item.section,
        message = "<center><img src=\"" .. icon_path .. "\">"
    }, GUI.HBoxContent)
    
    GUI[item.section]:setStyleSheet(GUI.BoxContentButtonCSS:getCSS())
    GUI[item.section]:setClickCallback("on_content_box_press", item.section)
    GUI[item.section]:setOnEnter("enable_tooltip", GUI[item.section], "<center><img src=\"" .. icon_path .. "\"><br>" .. item.tooltip)
    GUI[item.section]:setOnLeave("disable_tooltip", GUI[item.section], "<center><img src=\"" .. icon_path .. "\">")
end

-- Create labels for each content item
for _, item in ipairs(content_items) do
    createLabel(item)
end

-- Main content display box
GUI.ContentBox = Geyser.Label:new({
    name = "GUI.ContentBox",
    x = 0,
    y = "50%",
    width = "50%",
    height = "39%"
}, GUI.Right)
GUI.ContentBox:setStyleSheet(GUI.BoxRightCSS:getCSS())

-- Helper function to initialize consoles
local function initializeConsole(item)
    GUI[item.console] = Geyser.MiniConsole:new({
        name = "GUI." .. item.console,
        x = GUI.ContentBox:get_x(),
        y = GUI.ContentBox:get_y(),
        height = GUI.ContentBox:get_height(),
        width = GUI.ContentBox:get_width()
    })
    setBackgroundColor("GUI." .. item.console, 0, 0, 0, 0)
    setFont("GUI." .. item.console, getFont())
    setMiniConsoleFontSize("GUI." .. item.console, content_preferences["GUI." .. item.console].fontSize)
    setFgColor("GUI." .. item.console, 192, 192, 192)
    setBgColor("GUI." .. item.console, 0, 0, 0)
    GUI[item.console]:enableAutoWrap()

    -- Create and style '+' and '-' labels
    createControlLabel(item.console, "Plus", "-50px", "+")
    createControlLabel(item.console, "Minus", "-25px", "-")

    -- Connect labels to font adjustment functions
    GUI[item.console .. "PlusLabel"]:setClickCallback(increaseFontSize, GUI[item.console])
    GUI[item.console .. "MinusLabel"]:setClickCallback(decreaseFontSize, GUI[item.console])

    GUI[item.console]:hide()
end

-- Initialize all consoles except the Mapper
for _, item in ipairs(content_items) do
    if item.console ~= "MapperConsole" then
        initializeConsole(item)
    end
end
