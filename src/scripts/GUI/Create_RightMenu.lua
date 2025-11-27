-- Menu items data
local menu_items = {
    { name = "BoxPlayers", icon = "020-videoconference.png", tooltip = "Players", console = "PlayersScrollBox", gmcp_calls = {"Game.Players.List"} },
    { name = "BoxAbilities", icon = "021-self-improvement.png", tooltip = "Abilities", console = "AbilitiesConsole", gmcp_calls = {"Char.Guild.Help.List"} },
    { name = "BoxTraining", icon = "022-skill.png", tooltip = "Training", console = "TrainingScrollBox", gmcp_calls = {"Char.Session.Training", "Char.Training.List"} },
    { name = "BoxSession", icon = "023-hourglass.png", tooltip = "Session", console = "SessionScrollBox", gmcp_calls = {"Char.Session.Training"} },
    { name = "BoxGroup", icon = "024-drakkar.png", tooltip = "Party", console = "GroupScrollBox", gmcp_calls = {"Group"} },
    { name = "BoxEvents", icon = "schedule.png", tooltip = "Events", console = "EventsScrollBox", gmcp_calls = {"Game.Events.Active", "Char.Events.Session"} },
    { name = "BoxHelp", icon = "025-pen-and-ink.png", tooltip = "Help", console = "HelpContainer", gmcp_calls = {"Char.Help.List"} }
}

-- Main menu box and initial console visibility settings
GUI.MenuBox = Geyser.Label:new({
    name = "GUI.MenuBox",
    x = "50%",
    y = "7%",
    width = "50%",
    height = "85%"
}, GUI.Right)
setBackgroundColor("GUI.MenuBox", 0, 0, 0)

-- Function to handle menu box presses
function on_menu_box_press(section)
    for _, item in ipairs(menu_items) do
        if item.name == section then
            GUI[item.console]:show()
            selected_console = item.console
            if item.gmcp_calls then
                for _, call in ipairs(item.gmcp_calls) do
                    sendGMCP(call)
                end
            end
            -- Call display function for EventsScrollBox when shown
            -- This will show cached data or placeholder while waiting for GMCP response
            if item.console == "EventsScrollBox" then
                CharEventsList()
            end
        else
            GUI[item.console]:hide()
        end
    end
end

-- CSS for menu buttons
GUI.BoxMenuButtonCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]])

-- Function to create menu label with icon and tooltip
local function createMenuLabel(item)
    local icon_path = getMudletHomeDir() .. "/StickMUD/" .. item.icon
    GUI[item.name] = Geyser.Label:new({
        name = "GUI." .. item.name,
        message = "<center><img src=\"" .. icon_path .. "\">"
    }, GUI.HBoxMenu)

    GUI[item.name]:setStyleSheet(GUI.BoxMenuButtonCSS:getCSS())
    GUI[item.name]:setClickCallback("on_menu_box_press", item.name)
    GUI[item.name]:setOnEnter("enable_tooltip", GUI[item.name], "<center><img src=\"" .. icon_path .. "\"><br>" .. item.tooltip)
    GUI[item.name]:setOnLeave("disable_tooltip", GUI[item.name], "<center><img src=\"" .. icon_path .. "\">")
end

-- Function to initialize consoles
local function initializeConsole(item)
    local console_type = item.console:find("Console") and "MiniConsole" or item.console:find("Container") and "Container" or "ScrollBox"
    local console_settings = {
        name = "GUI." .. item.console,
        x = 0,
        y = 0,
        height = "100%",
        width = "100%"
    }

    GUI[item.console] = Geyser[console_type]:new(console_settings, GUI.MenuBox)
    setBackgroundColor("GUI." .. item.console, 0, 0, 0, 255)

    if console_type == "MiniConsole" then
        setFont("GUI." .. item.console, getFont())
        setMiniConsoleFontSize("GUI." .. item.console, content_preferences["GUI." .. item.console].fontSize)
        setFgColor("GUI." .. item.console, 192, 192, 192)
        setBgColor("GUI." .. item.console, 0, 0, 0)
        GUI[item.console]:enableAutoWrap()

        -- Create '+' and '-' labels
        createControlLabel(item.console, "Plus", "-50px", "+")
        createControlLabel(item.console, "Minus", "-25px", "-")

        -- Connect labels to font adjustment functions
        GUI[item.console .. "PlusLabel"]:setClickCallback(increaseFontSize, GUI[item.console])
        GUI[item.console .. "MinusLabel"]:setClickCallback(decreaseFontSize, GUI[item.console])
    end
    GUI[item.console]:hide()
end

-- Create main container for menu buttons
GUI.HBoxMenu = Geyser.HBox:new({
    name = "GUI.HBoxMenu",
    x = "50%",
    y = 0,
    width = "50%",
    height = "7%"
}, GUI.Right)

-- Initialize menu labels and consoles
for _, item in ipairs(menu_items) do
    createMenuLabel(item)
    initializeConsole(item)
end

-- Show the players' scroll box by default
GUI["HelpContainer"]:hide()
GUI["PlayersScrollBox"]:show()