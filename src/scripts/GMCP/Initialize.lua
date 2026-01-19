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

-- Retry state for GMCP data refresh (preserved across reloads)
GUI.GMCPRetryState = GUI.GMCPRetryState or {
    Vitals = { count = 0, interval = 10 },
    Status = { count = 0, interval = 10 },
    Players = { count = 0, interval = 10 }
}
GUI.GMCPMaxRetries = 5  -- Stop after this many attempts
GUI.GMCPBaseInterval = 10  -- Base interval in seconds
GUI.GMCPTimers = GUI.GMCPTimers or {}

-- Function to reset retry state for a specific GMCP type
function ResetGMCPRetryState(gmcpType)
    if GUI.GMCPRetryState[gmcpType] then
        GUI.GMCPRetryState[gmcpType].count = 0
        GUI.GMCPRetryState[gmcpType].interval = GUI.GMCPBaseInterval
    end
end

-- Connection guard helper
function IsGMCPConnected()
    return (GUI and GUI.isConnected) or 
           (gmcp and gmcp.Char) or 
           (getNetworkLatency and getNetworkLatency() > 0)
end

-- Function to check and refresh Char.Vitals
function CheckVitalsAndRefresh()
    -- Check if Vitals data exists
    if gmcp and gmcp.Char and gmcp.Char.Vitals and gmcp.Char.Vitals.hp then
        ResetGMCPRetryState("Vitals")
        return
    end
    
    if not IsGMCPConnected() then return end
    
    local state = GUI.GMCPRetryState.Vitals
    if state.count >= GUI.GMCPMaxRetries then return end
    
    state.count = state.count + 1
    sendGMCP("Char.Vitals")
    state.interval = math.min(state.interval * 2, 300)
end

-- Function to check and refresh Char.Status
function CheckStatusAndRefresh()
    -- Check if Status data exists
    if gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.gold then
        ResetGMCPRetryState("Status")
        return
    end
    
    if not IsGMCPConnected() then return end
    
    local state = GUI.GMCPRetryState.Status
    if state.count >= GUI.GMCPMaxRetries then return end
    
    state.count = state.count + 1
    sendGMCP("Char.Status")
    state.interval = math.min(state.interval * 2, 300)
end

-- Function to check and refresh Game.Players.List
function CheckPlayersAndRefresh()
    -- Check if Players data exists (List is a table)
    if gmcp and gmcp.Game and gmcp.Game.Players and gmcp.Game.Players.List and next(gmcp.Game.Players.List) ~= nil then
        ResetGMCPRetryState("Players")
        return
    end
    
    if not IsGMCPConnected() then return end
    
    local state = GUI.GMCPRetryState.Players
    if state.count >= GUI.GMCPMaxRetries then return end
    
    state.count = state.count + 1
    sendGMCP("Game.Players.List")
    state.interval = math.min(state.interval * 2, 300)
end

-- Kill existing timers
for name, timerId in pairs(GUI.GMCPTimers) do
    if timerId then killTimer(timerId) end
end
GUI.GMCPTimers = {}

-- Schedule functions for each GMCP type
function ScheduleGMCPCheck(gmcpType, checkFunc)
    local timerName = "GMCP" .. gmcpType
    if GUI.GMCPTimers[timerName] then
        killTimer(GUI.GMCPTimers[timerName])
    end
    GUI.GMCPTimers[timerName] = tempTimer(GUI.GMCPRetryState[gmcpType].interval, function()
        checkFunc()
        ScheduleGMCPCheck(gmcpType, checkFunc)
    end)
end

-- Initial requests (immediate)
sendGMCP("Char.Vitals")
sendGMCP("Char.Status")
sendGMCP("Game.Players.List")

-- Start periodic checks with backoff
ScheduleGMCPCheck("Vitals", CheckVitalsAndRefresh)
ScheduleGMCPCheck("Status", CheckStatusAndRefresh)
ScheduleGMCPCheck("Players", CheckPlayersAndRefresh)