abilitiesTimers = {}

-- Initialize GUI elements to default state before GMCP data is available
tempTimer(
  0.5,
  function()
    -- Initialize vitals and status displays to default empty state
    if InitializeVitals then InitializeVitals() end
    if InitializeStatus then InitializeStatus() end
    if InitializeRoomInfo then InitializeRoomInfo() end
    if InitializeInventoryConsoles then InitializeInventoryConsoles() end
  end
)

tempTimer(
  1.0,
  function()
    GUI.MapperConsole =
      GUI.MapperConsole or
      Geyser.Mapper:new(
        {name = "GUI.MapperConsole", x = 0, y = 0, height = "100%", width = "100%"}, GUI.ContentBox
      )
    on_content_box_press("BoxMap")
  end
)

-- Request GMCP data from server (will update GUI when responses arrive)

-- Declare supported GMCP packages to the server
local packages = {
    -- Core
    "Core 1",

    -- Character
    "Char 1",
    "Char.Vitals 1",          -- CharVitals.lua
    "Char.Status 1",          -- CharStatus.lua
    "Char.Items 1",           -- Inventory and Room item handlers
    "Char.Abilities 1",       -- AbilitiesButtons handlers
    "Char.Help 1",            -- HelpContainer/CharHelpList.lua
    "Char.Guild.Help 1",      -- AbilitiesConsole/CharGuildHelpList.lua
    "Char.Training 1",        -- TrainingScrollBox handlers
    "Char.Events 1",          -- EventsScrollBox/CharEventsList.lua

    -- Room
    "Room 1",                 -- RoomInfo.lua, Room.Players handlers

    -- Communication
    "Comm 1",
    "Comm.Channel 1",         -- CommChannelText.lua

    -- Group
    "Group 1",                -- GroupScrollBox/Group.lua

    -- Game
    "Game 1",
    "Game.Players 1",         -- PlayersScrollBox handlers
    "Game.Events 1",          -- EventsScrollBox/GameEvents handlers
    "Game.Info 1",            -- InfoScrollBox/GameInfo.lua
}
sendGMCP("Core.Supports.Add " .. yajl.to_string(packages))

sendGMCP("Char.Vitals")
sendGMCP("Char.Status")
sendGMCP("Game.Players.List")