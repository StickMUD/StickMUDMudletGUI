-- Consolidated chat items data structure
local chat_items = {
    { section = "BoxChatAll", icon = "055-chat.png", tooltip = "All", console = "ChatAllConsole" },
    { section = "BoxChatGuild", icon = "015-union.png", tooltip = "Guild", console = "ChatGuildConsole" },
    { section = "BoxChatClan", icon = "016-clan.png", tooltip = "Clan", console = "ChatClanConsole" },
    { section = "BoxChatTells", icon = "017-telepathy.png", tooltip = "Tells", console = "ChatTellsConsole" },
    { section = "BoxChatLocal", icon = "018-qa.png", tooltip = "Local", console = "ChatLocalConsole" },
    { section = "BoxChatClear", icon = "019-can.png", tooltip = "Clear" }
}

-- Function to handle chat box presses
function on_chat_box_press(section)
    local isClear = section == "BoxChatClear"
    for _, item in ipairs(chat_items) do
        local console = item.console
        if isClear and console then
            clearWindow("GUI." .. console)
        elseif item.section == section and console then
            GUI[console]:show()
        elseif console then
            GUI[console]:hide()
        end
    end
    if isClear then GUI["ChatAllConsole"]:show() end
end

-- CSS for chat buttons
GUI.BoxChatButtonCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  border-style: solid;
  border-color: #31363b;
  border-width: 1px;
]])

-- Main container for chat buttons
GUI.HBoxChat = Geyser.HBox:new({
    name = "GUI.HBoxChat",
    x = 0,
    y = 0,
    width = "50%",
    height = "5%"
}, GUI.Right)

-- Function to create a chat label with icon and tooltip
local function createChatLabel(item)
    local icon_path = getMudletHomeDir() .. "/StickMUD/" .. item.icon
    GUI[item.section] = Geyser.Label:new({
        name = "GUI." .. item.section,
        message = "<center><font size=\"6\"><img src=\"" .. icon_path .. "\"></font></center>"
    }, GUI.HBoxChat)

    GUI[item.section]:setStyleSheet(GUI.BoxChatButtonCSS:getCSS())
    GUI[item.section]:setClickCallback("on_chat_box_press", item.section)
    GUI[item.section]:setOnEnter("enable_tooltip", GUI[item.section], "<center><b><font size=\"3\"><img src=\"" .. icon_path .. "\"></font></b><br>" .. item.tooltip)
    GUI[item.section]:setOnLeave("disable_tooltip", GUI[item.section], "<center><b><font size=\"6\"><img src=\"" .. icon_path .. "\"></font></b>")
end

-- Create labels for each chat item
for _, item in ipairs(chat_items) do
    createChatLabel(item)
end

-- Function to toggle double spacing
local function toggleDoublespace(consoleName, value)
    if content_preferences[consoleName] then
        content_preferences[consoleName].doublespace = value
        table.save(content_preferences_file, content_preferences)
    end
end

-- Function to toggle timestamp
local function toggleTimestamp(consoleName, value)
    if content_preferences[consoleName] then
        content_preferences[consoleName].timestamp = value
        table.save(content_preferences_file, content_preferences)
    end
end

-- Helper function to initialize a chat console
local function initializeConsole(item)
    if not item.console then return end

    GUI[item.console] = Geyser.MiniConsole:new({
        name = "GUI." .. item.console,
        x = GUI.ChatBox:get_x(),
        y = GUI.ChatBox:get_y(),
        height = GUI.ChatBox:get_height(),
        width = GUI.ChatBox:get_width()
    })
    
    local consoleName = "GUI." .. item.console
    setBackgroundColor(consoleName, 0, 0, 0, 0)
    setFont(consoleName, getFont())
    setMiniConsoleFontSize(consoleName, content_preferences[consoleName].fontSize or getDefaultConsoleFontSize())
    setFgColor(consoleName, 192, 192, 192)
    setBgColor(consoleName, 0, 0, 0)
    GUI[item.console]:enableAutoWrap()

    -- Create and style '+' and '-' labels
    createControlLabel(item.console, "Plus", "-100px", "+")
    createControlLabel(item.console, "Minus", "-75px", "-")
    GUI[item.console .. "PlusLabel"]:setClickCallback(increaseFontSize, GUI[item.console])
    GUI[item.console .. "MinusLabel"]:setClickCallback(decreaseFontSize, GUI[item.console])

    -- Doublespace button
    GUI[item.console .. "DoublespaceButton"] = Geyser.Button:new({
        name = item.console .. "DoublespaceButton",
        x = "-50px",
        y = "0px",
        width = "25px",
        height = "25px",
        clickFunction = function() toggleDoublespace(consoleName, false) end,
        downFunction = function() toggleDoublespace(consoleName, true) end,
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
    }, GUI[item.console])

    if content_preferences[consoleName] and content_preferences[consoleName].doublespace then
        GUI[item.console .. "DoublespaceButton"]:setState("up")
    else
        GUI[item.console .. "DoublespaceButton"]:setState("down")
    end

    -- Timestamp button
    GUI[item.console .. "TimestampButton"] = Geyser.Button:new({
        name = item.console .. "TimestampButton",
        x = "-25px",
        y = "0px",
        width = "25px",
        height = "25px",
        clickFunction = function() toggleTimestamp(consoleName, false) end,
        downFunction = function() toggleTimestamp(consoleName, true) end,
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
    }, GUI[item.console])

    if content_preferences[consoleName] and content_preferences[consoleName].timestamp then
        GUI[item.console .. "TimestampButton"]:setState("up")
    else
        GUI[item.console .. "TimestampButton"]:setState("down")
    end

    GUI[item.console]:hide() -- Initially hide all consoles
end

-- Create the main chat display box and initialize consoles
GUI.ChatBox = Geyser.Label:new({
    name = "GUI.ChatBox",
    x = 0,
    y = "5%",
    width = "50%",
    height = "40%"
}, GUI.Right)
GUI.ChatBox:setStyleSheet(GUI.BoxRightCSS:getCSS())

for _, item in ipairs(chat_items) do
    initializeConsole(item)
end

-- Default to "All" chat window
on_chat_box_press("BoxChatAll")
