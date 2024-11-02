chat_sections = {
    "BoxChatAll", "BoxChatGuild", "BoxChatClan", "BoxChatTells", "BoxChatLocal",
    "BoxChatClear"
}
chat_icons = {
    "015-union.png", "015-union.png", "016-clan.png", "017-telepathy.png",
    "018-qa.png", "019-can.png"
}
chat_tooltips = {"All", "Guild", "Clan", "Tells", "Local", "Clear"}
chat_consoles = {
    "ChatAllConsole", "ChatGuildConsole", "ChatClanConsole", "ChatTellsConsole",
    "ChatLocalConsole"
}

-- Function to handle chat box presses
function on_chat_box_press(section)
    local isClear = section == "BoxChatClear"
    for index, console_value in ipairs(chat_consoles) do
        if isClear then
            clearWindow("GUI." .. console_value)
        elseif chat_sections[index] == section then
            GUI[console_value]:show()
        else
            GUI[console_value]:hide()
        end
    end
    -- Reset to main chat after clearing
    if isClear then GUI["ChatAllConsole"]:show() end
end

-- CSS for chat buttons
GUI.BoxChatButtonCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]])

-- Helper function to create label with icon and tooltip
local function createChatLabel(index)
    local section_value = chat_sections[index]
    local icon_value = getMudletHomeDir() .. "/StickMUD/" .. chat_icons[index]
    local tooltip_value = chat_tooltips[index]

    GUI[section_value] = Geyser.Label:new({
        name = "GUI." .. section_value,
        message = "<center><font size=\"6\"><img src=\"" .. icon_value ..
            "\"></font></center>"
    }, GUI.HBoxChat)

    GUI[section_value]:setStyleSheet(GUI.BoxChatButtonCSS:getCSS())
    GUI[section_value]:setClickCallback("on_chat_box_press", section_value)

    -- Set tooltips for hover behavior
    GUI[section_value]:setOnEnter("enable_tooltip", GUI[section_value],
                                  "<center><b><font size=\"3\"><img src=\"" ..
                                      icon_value .. "\"></font></b><br>" ..
                                      tooltip_value)
    GUI[section_value]:setOnLeave("disable_tooltip", GUI[section_value],
                                  "<center><b><font size=\"6\"><img src=\"" ..
                                      icon_value .. "\"></font></b>")
end

-- Function to toggle doublespace
local function toggleDoublespace(consoleName, value)
    if content_preferences[consoleName] then
        content_preferences[consoleName].doublespace = value

        -- Save the updated content_preferences if any keys were added
        table.save(content_preferences_file, content_preferences)
    end
end

-- Function to toggle timestamp
local function toggleTimestamp(consoleName, value)
    if content_preferences[consoleName] then
        content_preferences[consoleName].timestamp = value

        -- Save the updated content_preferences if any keys were added
        table.save(content_preferences_file, content_preferences)
    end
end

-- Helper function to initialize consoles
local function initializeConsole(index)
    local console_value = chat_consoles[index]
    GUI[console_value] = GUI[console_value] or Geyser.MiniConsole:new({
        name = "GUI." .. console_value,
        x = GUI.ChatBox:get_x(),
        y = GUI.ChatBox:get_y(),
        height = GUI.ChatBox:get_height(),
        width = GUI.ChatBox:get_width()
    })
    setBackgroundColor("GUI." .. console_value, 0, 0, 0, 0)
    setFont("GUI." .. console_value, getFont())
    setMiniConsoleFontSize("GUI." .. console_value,
                           content_preferences["GUI." .. console_value].fontSize)
    setFgColor("GUI." .. console_value, 192, 192, 192)
    setBgColor("GUI." .. console_value, 0, 0, 0)
    GUI[console_value]:enableAutoWrap()

    -- Create and style '+' and '-' labels
    createControlLabel(console_value, "Plus", "-100px", "+")
    createControlLabel(console_value, "Minus", "-75px", "-")

    -- Connect labels to font adjustment functions
    GUI[console_value .. "PlusLabel"]:setClickCallback(increaseFontSize,
                                                       GUI[console_value])
    GUI[console_value .. "MinusLabel"]:setClickCallback(decreaseFontSize,
                                                        GUI[console_value])

    GUI[console_value .. "DoublespaceButton"] = Geyser.Button:new({
        name = "GUI." .. console_value .. "DoublespaceButton",
        x = "-50px",
        y = "0px",
        width = "25px",
        height = "25px",
        clickFunction = function()
            toggleDoublespace("GUI." .. console_value, false)
        end,
        downFunction = function()
            toggleDoublespace("GUI." .. console_value, true)
        end,
        msg = "<center><font size=\"4\" color=\"blue\">2</font></center>",
        downMsg = "<center><font size=\"4\" color=\"blue\">1</font></center>",
        tooltip = "Click for single spacing",
        downTooltip = "Click for double spacing",
        twoState = true,
        style = [[
          background-color: #transparent;
          color: white;
          font-size: 16px;
          text-align: center;
          border: 0px solid #000000;
        ]],
        downStyle = [[
          background-color: #transparent;
          color: white;
          font-size: 16px;
          text-align: center;
          border: 0px solid #000000;
        ]]
    }, GUI[console_value])

    if content_preferences["GUI." .. console_value] and
        content_preferences["GUI." .. console_value].doublespace then
        GUI[console_value .. "DoublespaceButton"]:setState("up")
    else
        GUI[console_value .. "DoublespaceButton"]:setState("down")
    end

    GUI[console_value .. "TimestampButton"] = Geyser.Button:new({
        name = "GUI." .. console_value .. "TimestampButton",
        x = "-25px",
        y = "0px",
        width = "25px",
        height = "25px",
        clickFunction = function()
            toggleTimestamp("GUI." .. console_value, false)
        end,
        downFunction = function()
            toggleTimestamp("GUI." .. console_value, true)
        end,
        msg = "<center><font size=\"4\">🕰️</font></center>",
        downMsg = "<center><font size=\"4\" color=\"yellow\">X</font></center>",
        tooltip = "Click for no timestamp",
        downTooltip = "Click for timestamp",
        twoState = true,
        style = [[
          background-color: #transparent;
          color: white;
          font-size: 16px;
          text-align: center;
          border: 0px solid #000000;
        ]],
        downStyle = [[
          background-color: #transparent;
          color: white;
          font-size: 16px;
          text-align: center;
          border: 0px solid #000000;
        ]]
    }, GUI[console_value])

    if content_preferences["GUI." .. console_value] and
        content_preferences["GUI." .. console_value].timestamp then
        GUI[console_value .. "TimestampButton"]:setState("up")
    else
        GUI[console_value .. "TimestampButton"]:setState("down")
    end

    GUI[console_value]:hide() -- Initially hide all consoles
end

-- Create chat button labels
GUI.HBoxChat = Geyser.HBox:new({
    name = "GUI.HBoxChat",
    x = 0,
    y = 0,
    width = "50%",
    height = "5%"
}, GUI.Right)

for index = 1, #chat_sections do createChatLabel(index) end

-- Create chat console boxes
GUI.ChatBox = Geyser.Label:new({
    name = "GUI.ChatBox",
    x = 0,
    y = "5%",
    width = "50%",
    height = "40%"
}, GUI.Right)
GUI.ChatBox:setStyleSheet(GUI.BoxRightCSS:getCSS())

for index = 1, #chat_consoles do initializeConsole(index) end

-- Default to "All" chat window
on_chat_box_press("BoxChatAll")
