menu_sections = {
    "BoxPlayers", "BoxAbilities", "BoxTraining", "BoxSession", "BoxGroup",
    "BoxHelp"
}
menu_icons = {
    "020-videoconference.png", "021-sel-improvement.png", "022-skill.png",
    "023-hourglass.png", "024-drakkar.png", "025-pen-and-ink.png"
}
menu_tooltips = {"Players", "Abilities", "Training", "Session", "Party", "Help"}
menu_consoles = {
    "PlayersScrollBox", "AbilitiesConsole", "TrainingScrollBox",
    "SessionScrollBox", "GroupConsole", "HelpContainer"
}
selected_console = "PlayersScrollBox"

-- Map sections to GMCP calls
local gmcp_calls = {
    BoxPlayers = {"Game.Players.List"},
    BoxAbilities = {"Char.Guild.Help.List"},
    BoxTraining = {"Char.Session.Training", "Char.Training.List"},
    BoxSession = {"Char.Session.Training"},
    BoxHelp = {"Char.Help.List"}
}

-- Function to handle menu box presses
function on_menu_box_press(section)
    for index, section_value in ipairs(menu_sections) do
        local console_value = menu_consoles[index]
        if section_value == section then
            GUI[console_value]:show()
            -- Send the appropriate GMCP calls
            if gmcp_calls[section] then
                for _, call in ipairs(gmcp_calls[section]) do
                    sendGMCP(call)
                end
            end
            selected_console = console_value
        else
            GUI[console_value]:hide()
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

-- Helper function to create a menu label with icon and tooltip
local function createMenuLabel(index)
    local section_value = menu_sections[index]
    local icon_value = getMudletHomeDir() .. "/StickMUD/" .. menu_icons[index]
    local tooltip_value = menu_tooltips[index]

    GUI[section_value] = Geyser.Label:new({
        name = "GUI." .. section_value,
        message = "<center><font size=\"6\"><img src=\"" .. icon_value ..
            "\"></font></center>"
    }, GUI.HBoxMenu)

    GUI[section_value]:setStyleSheet(GUI.BoxMenuButtonCSS:getCSS())
    GUI[section_value]:setClickCallback("on_menu_box_press", section_value)

    -- Set tooltips for hover behavior
    GUI[section_value]:setOnEnter("enable_tooltip", GUI[section_value],
                                  "<center><b><font size=\"3\"><img src=\"" ..
                                      icon_value .. "\"></font></b><br>" ..
                                      tooltip_value)
    GUI[section_value]:setOnLeave("disable_tooltip", GUI[section_value],
                                  "<center><b><font size=\"6\"><img src=\"" ..
                                      icon_value .. "\"></font></b>")
end

-- Helper function to initialize consoles
local function initializeConsole(console_value, console_type)
    if console_type == "MiniConsole" then
        GUI[console_value] = Geyser.MiniConsole:new({
            name = "GUI." .. console_value,
            x = GUI.MenuBox:get_x(),
            y = GUI.MenuBox:get_y(),
            height = GUI.MenuBox:get_height(),
            width = GUI.MenuBox:get_width()
        })
    elseif console_type == "Container" then
        GUI[console_value] = Geyser.Container:new({
            name = "GUI." .. console_value,
            x = GUI.MenuBox:get_x(),
            y = GUI.MenuBox:get_y(),
            height = GUI.MenuBox:get_height(),
            width = GUI.MenuBox:get_width()
        })
    elseif console_type == "ScrollBox" then
        GUI[console_value] = Geyser.ScrollBox:new({
            name = "GUI." .. console_value,
            x = GUI.MenuBox:get_x(),
            y = GUI.MenuBox:get_y(),
            height = GUI.MenuBox:get_height() * 4,
            width = GUI.MenuBox:get_width()
        })
    end

    setBackgroundColor("GUI." .. console_value, 0, 0, 0, 255)
    if console_type == "MiniConsole" then
        setFont("GUI." .. console_value, getFont())
        setMiniConsoleFontSize("GUI." .. console_value,
                               content_preferences["GUI." .. console_value]
                                   .fontSize)
        setFgColor("GUI." .. console_value, 192, 192, 192)
        setBgColor("GUI." .. console_value, 0, 0, 0)
        GUI[console_value]:enableAutoWrap()

        -- Create and style '+' and '-' labels
        createControlLabel(console_value, "Plus", "-50px", "+")
        createControlLabel(console_value, "Minus", "-25px", "-")

        -- Connect labels to font adjustment functions
        GUI[console_value .. "PlusLabel"]:setClickCallback(increaseFontSize,
                                                           GUI[console_value])
        GUI[console_value .. "MinusLabel"]:setClickCallback(decreaseFontSize,
                                                            GUI[console_value])
    end
    GUI[console_value]:hide()
end

-- Create menu button labels
GUI.HBoxMenu = Geyser.HBox:new({
    name = "GUI.HBoxMenu",
    x = "50%",
    y = 0,
    width = "50%",
    height = "5%"
}, GUI.Right)

for index = 1, #menu_sections do createMenuLabel(index) end

-- Create consoles
GUI.MenuBox = Geyser.Label:new({
    name = "GUI.MenuBox",
    x = "50%",
    y = "5%",
    width = "50%",
    height = "89%"
}, GUI.Right)
setBackgroundColor("GUI.MenuBox", 0, 0, 0)

for index, console_value in ipairs(menu_consoles) do
    if console_value:find("Console") then
        initializeConsole(console_value, "MiniConsole")
    elseif console_value:find("Container") then
        initializeConsole(console_value, "Container")
    else
        initializeConsole(console_value, "ScrollBox")
    end
end

-- Initial state: Show the players' scroll box
GUI["HelpContainer"]:hide()
GUI["PlayersScrollBox"]:show()
