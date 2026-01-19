-- CSS for the left panel
GUI.BoxLeftCSS = CSSMan.new([[
    background-color: rgba(0,0,0,255);
    qproperty-wordWrap: true;
]])

-- ============================================
-- INCENTIVE SECTION (top portion)
-- ============================================

-- Title label for Incentive (pillbox style like header) - at top
GUI.IncentiveTitle = GUI.IncentiveTitle or Geyser.Label:new({
    name = "GUI.IncentiveTitle",
    x = "2px", y = "2px",
    width = "-4px",
    height = "24px"
}, GUI.Middle)

GUI.IncentiveTitle:setStyleSheet([[
    background-color: #222230;
    border: 1px solid #32323f;
    border-radius: 6px;
]])
GUI.IncentiveTitle:echo([[<center><font size="3" color="#888">🎯 Daily Incentive</font></center>]])

-- Container for incentive gauges - below title
GUI.IncentiveContainer = GUI.IncentiveContainer or Geyser.Label:new({
    name = "GUI.IncentiveContainer",
    x = 0, y = "28px",
    width = "100%",
    height = "140px"
}, GUI.Middle)
GUI.IncentiveContainer:setStyleSheet([[background-color: rgba(0,0,0,255);]])

-- Storage for incentive state
GUI.IncentiveData = GUI.IncentiveData or {
    active = "No",
    eligible = "No",
    all_complete = "No",
    base_complete = "No",
    base_progress = 0,
    m1_complete = "No",
    m1_progress = 0,
    m2_complete = "No",
    m2_progress = 0,
    m3_complete = "No",
    m3_progress = 0,
    next_milestone = 0,
    time_remaining = 0
}

-- CSS styles for incentive gauges
GUI.IncentiveGaugeBackCSS = CSSMan.new([[
    background-color: #1a1a1a;
    border: 1px solid #333;
    border-radius: 4px;
    margin: 2px 4px;
]])

GUI.IncentiveGaugeFrontCSS = CSSMan.new([[
    border: none;
    border-radius: 4px;
    margin: 2px 4px;
]])

-- Colors for incentive gauges
GUI.IncentiveColors = {
    inactive = {front = "#444", back = "#222"},      -- Grey for inactive/ineligible
    incomplete = {front = "#2980b9", back = "#164666"},  -- Blue for in progress
    complete = {front = "#27ae60", back = "#0d3d1a"},    -- Green for complete
    base = {front = "#f39c12", back = "#4d3205"}         -- Orange for base goal
}

-- Helper function to format time remaining
function formatIncentiveTime(seconds)
    if not seconds or seconds <= 0 then
        return "Cycle Complete"
    end
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    return string.format("%dh %dm remaining", hours, mins)
end

-- Create incentive gauges
GUI.IncentiveGauges = GUI.IncentiveGauges or {}

-- Hide existing gauges on reload
for name, gauge in pairs(GUI.IncentiveGauges) do
    if gauge and gauge.hide then gauge:hide() end
end

-- Create the four gauges: Base, M1, M2, M3
local incentiveLabels = {
    {key = "base", label = "Base (50M)", y = 0},
    {key = "m1", label = "M1 (150M)", y = 26},
    {key = "m2", label = "M2 (450M)", y = 52},
    {key = "m3", label = "M3 (900M)", y = 78}
}

for _, info in ipairs(incentiveLabels) do
    local gauge = Geyser.Gauge:new({
        name = "GUI.IncentiveGauge_" .. info.key,
        x = 0, y = info.y .. "px",
        width = "100%", height = "24px"
    }, GUI.IncentiveContainer)
    
    GUI.IncentiveGaugeBackCSS:set("background-color", GUI.IncentiveColors.inactive.back)
    gauge.back:setStyleSheet(GUI.IncentiveGaugeBackCSS:getCSS())
    GUI.IncentiveGaugeFrontCSS:set("background-color", GUI.IncentiveColors.inactive.front)
    gauge.front:setStyleSheet(GUI.IncentiveGaugeFrontCSS:getCSS())
    
    gauge:setValue(0, 100, string.format([[<center><font size="3" color="#666">%s</font></center>]], info.label))
    gauge:show()
    
    GUI.IncentiveGauges[info.key] = gauge
end

-- Time remaining label
GUI.IncentiveTimeLabel = GUI.IncentiveTimeLabel or Geyser.Label:new({
    name = "GUI.IncentiveTimeLabel",
    x = 0, y = "104px",
    width = "100%", height = "20px"
}, GUI.IncentiveContainer)
GUI.IncentiveTimeLabel:setStyleSheet([[background-color: rgba(0,0,0,255);]])
GUI.IncentiveTimeLabel:echo([[<center><font size="2" color="#666">Not Active</font></center>]])

-- Function to update incentive display
function RefreshIncentiveDisplay()
    local data = GUI.IncentiveData
    
    -- Check if eligible and active
    local isActive = data.eligible == "Yes" and data.active == "Yes"
    
    -- Update each gauge
    local gaugeInfo = {
        {key = "base", progress = data.base_progress, complete = data.base_complete, label = "Base (50M)", colors = GUI.IncentiveColors.base},
        {key = "m1", progress = data.m1_progress, complete = data.m1_complete, label = "M1 (150M)", colors = GUI.IncentiveColors.incomplete},
        {key = "m2", progress = data.m2_progress, complete = data.m2_complete, label = "M2 (450M)", colors = GUI.IncentiveColors.incomplete},
        {key = "m3", progress = data.m3_progress, complete = data.m3_complete, label = "M3 (900M)", colors = GUI.IncentiveColors.incomplete}
    }
    
    for _, info in ipairs(gaugeInfo) do
        local gauge = GUI.IncentiveGauges[info.key]
        if gauge then
            local progress = tonumber(info.progress) or 0
            local isComplete = info.complete == "Yes"
            local colors
            local textColor
            
            if not isActive then
                colors = GUI.IncentiveColors.inactive
                textColor = "#666"
                progress = 0
            elseif isComplete then
                colors = GUI.IncentiveColors.complete
                textColor = "white"
                progress = 100
            else
                colors = info.colors
                textColor = "white"
            end
            
            GUI.IncentiveGaugeBackCSS:set("background-color", colors.back)
            gauge.back:setStyleSheet(GUI.IncentiveGaugeBackCSS:getCSS())
            GUI.IncentiveGaugeFrontCSS:set("background-color", colors.front)
            gauge.front:setStyleSheet(GUI.IncentiveGaugeFrontCSS:getCSS())
            
            local statusText = isComplete and "✓" or string.format("%d%%", progress)
            local labelText = string.format([[<center><font size="3" color="%s"><b>%s</b> %s</font></center>]], 
                textColor, info.label, isActive and statusText or "")
            gauge:setValue(progress, 100, labelText)
        end
    end
    
    -- Update time remaining
    if GUI.IncentiveTimeLabel then
        local timeText
        if data.eligible ~= "Yes" then
            timeText = [[<center><font size="2" color="#666">Lords Only</font></center>]]
        elseif data.active ~= "Yes" then
            timeText = [[<center><font size="2" color="#666">Not Active</font></center>]]
        elseif data.all_complete == "Yes" then
            timeText = [[<center><font size="2" color="#27ae60">All Milestones Complete! ✓</font></center>]]
        else
            local timeStr = formatIncentiveTime(tonumber(data.time_remaining) or 0)
            timeText = string.format([[<center><font size="2" color="#888">⏱ %s</font></center>]], timeStr)
        end
        GUI.IncentiveTimeLabel:echo(timeText)
    end
end

-- Initialize display
RefreshIncentiveDisplay()

-- ============================================
-- ABILITIES SECTION (bottom portion)
-- ============================================

-- Container for abilities list (simple Label, no scrolling) - below incentive
GUI.AbilitiesListContainer = Geyser.Label:new({
    name = "GUI.AbilitiesListContainer",
    x = 0, y = "170px",
    width = "100%",
    height = "-40px"
}, GUI.Middle)
GUI.AbilitiesListContainer:setStyleSheet([[background-color: rgba(0,0,0,255);]])

-- Title label for Abilities (pillbox style like header) - at bottom with 12px buffer
GUI.AbilitiesTitle = Geyser.Label:new({
    name = "GUI.AbilitiesTitle",
    x = "2px", y = "-38px",
    width = "-4px",
    height = "24px"
}, GUI.Middle)

GUI.AbilitiesTitle:setStyleSheet([[
    background-color: #222230;
    border: 1px solid #32323f;
    border-radius: 6px;
]])
GUI.AbilitiesTitle:echo([[<center><font size="3" color="#888">⚡ Abilities</font></center>]])

-- Storage for active abilities and their UI elements
-- Keyed by monitor ID for proper tracking of multiple abilities with same name
-- Use "or {}" pattern to preserve existing references across script reloads
GUI.ActiveAbilities = GUI.ActiveAbilities or {}
GUI.AbilityRows = GUI.AbilityRows or {}
GUI.AbilityTimers = GUI.AbilityTimers or {}

-- On script reload, hide all existing gauges (they'll be shown again if ability is still active)
for i, row in ipairs(GUI.AbilityRows) do
    if row and row.gauge then
        row.gauge:hide()
    end
end

-- Kill any existing timers (will be recreated if needed)
for id, timerId in pairs(GUI.AbilityTimers) do
    killTimer(timerId)
end
GUI.AbilityTimers = {}

-- Clear active abilities on reload (server will resend if still active)
GUI.ActiveAbilities = {}

-- CSS styles for ability gauges (inspired by footer)
GUI.AbilityGaugeBackCSS = CSSMan.new([[
    background-color: #1a1a1a;
    border: 1px solid #333;
    border-radius: 4px;
    margin: 2px 4px;
]])

GUI.AbilityGaugeFrontCSS = CSSMan.new([[
    border: none;
    border-radius: 4px;
    margin: 2px 4px;
]])

-- Color schemes for different ability states
GUI.AbilityColors = {
    warning = {front = "#f39c12", back = "#4d3205"},    -- Orange for warning
    expiring = {front = "#e74c3c", back = "#4a1a15"}    -- Red for expiring soon
}

-- Color palette for active abilities (good contrast with white text)
-- Each color has a front (gauge fill) and back (background) variant
GUI.AbilityColorPalette = {
    {front = "#2980b9", back = "#164666"},  -- Blue
    {front = "#8e44ad", back = "#4a2359"},  -- Purple
    {front = "#16a085", back = "#0d5c4c"},  -- Teal
    {front = "#27ae60", back = "#0d3d1a"},  -- Green
    {front = "#2c3e50", back = "#1a252f"},  -- Dark Blue Grey
    {front = "#d35400", back = "#6b2a00"},  -- Burnt Orange
    {front = "#1abc9c", back = "#0d5c4c"},  -- Turquoise
    {front = "#9b59b6", back = "#4d2c5b"},  -- Amethyst
    {front = "#3498db", back = "#1a4d6e"},  -- Light Blue
    {front = "#e91e63", back = "#730f31"},  -- Pink
}

-- Simple hash function to get consistent color index from ability name
function getAbilityColorIndex(name)
    local hash = 0
    for i = 1, #name do
        hash = hash + string.byte(name, i)
    end
    return (hash % #GUI.AbilityColorPalette) + 1
end

-- Helper function to get ability color based on state and name
function getAbilityColor(remaining, warn, name)
    if warn == 1 then
        return GUI.AbilityColors.warning
    elseif remaining and remaining > 0 and remaining <= 30 then
        return GUI.AbilityColors.expiring
    else
        -- Use name-based color for active abilities
        local colorIndex = getAbilityColorIndex(name or "default")
        return GUI.AbilityColorPalette[colorIndex]
    end
end

-- Helper function to format time remaining
function formatTimeRemaining(seconds)
    if not seconds or seconds <= 0 then
        return ""
    elseif seconds >= 3600 then
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        return string.format("%d:%02d:00", hours, mins)
    elseif seconds >= 60 then
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%d:%02d", mins, secs)
    else
        return string.format("0:%02d", seconds)
    end
end

-- Function to refresh the abilities display
function RefreshAbilitiesDisplay()
    -- Get sorted list of abilities (sort by remaining time: longest at top, shortest at bottom)
    local sortedAbilities = {}
    for id, ability in pairs(GUI.ActiveAbilities) do
        table.insert(sortedAbilities, {id = id, name = ability.name, data = ability})
    end
    table.sort(sortedAbilities, function(a, b)
        -- Get remaining times (treat nil or 0 as infinite/permanent)
        local aRemaining = a.data.remaining or math.huge
        local bRemaining = b.data.remaining or math.huge
        if aRemaining == 0 then aRemaining = math.huge end
        if bRemaining == 0 then bRemaining = math.huge end
        -- Sort descending (longest time first/at top)
        return aRemaining > bRemaining
    end)
    
    -- Debug: echo("[RefreshDisplay] Active abilities count: " .. #sortedAbilities .. ", GUI.AbilityRows count: " .. #GUI.AbilityRows .. "\n")
    
    -- Calculate row height
    local rowHeight = 30
    local totalHeight = #sortedAbilities * rowHeight
    
    -- Hide any extra rows from previous render
    -- Debug: echo("[RefreshDisplay] Hiding rows from " .. (#sortedAbilities + 1) .. " to " .. #GUI.AbilityRows .. "\n")
    for i = #sortedAbilities + 1, #GUI.AbilityRows do
        if GUI.AbilityRows[i] and GUI.AbilityRows[i].gauge then
            -- Debug: echo("[RefreshDisplay] Hiding gauge " .. i .. "\n")
            GUI.AbilityRows[i].gauge:hide()
        end
    end
    
    -- Create or update rows for each ability
    -- Position from bottom of scrollbox (using negative y values)
    local numAbilities = #sortedAbilities
    for i, abilityInfo in ipairs(sortedAbilities) do
        -- Debug: echo("[RefreshDisplay] Processing ability " .. i .. ": " .. abilityInfo.name .. "\n")
        local ability = abilityInfo.data
        local name = abilityInfo.name
        local colors = getAbilityColor(ability.remaining, ability.warn, name)
        
        -- Calculate y position from bottom
        -- First ability (i=1) at top of stack, last ability at very bottom
        local yPos = "-" .. ((numAbilities - i + 1) * rowHeight) .. "px"
        
        -- Calculate gauge value (100% if no expiry, percentage if expiring)
        local gaugeValue = 100
        if ability.expires and ability.expires > 0 and ability.remaining then
            gaugeValue = math.max(0, math.min(100, (ability.remaining / ability.expires) * 100))
        end
        
        -- Format the label text (just the ability name, time shown via gauge fill)
        local labelText = string.format(
            [[<center><font size="3" color="white"><b>%s</b></font></center>]],
            firstToUpper(name)
        )
        
        local existingRow = GUI.AbilityRows[i]
        -- Debug: echo("[RefreshDisplay] Checking existing row: " .. tostring(existingRow ~= nil) .. ", gauge: " .. tostring(existingRow and existingRow.gauge ~= nil) .. "\n")
        
        if existingRow and existingRow.gauge then
            -- Debug: echo("[RefreshDisplay] Updating existing gauge\n")
            -- Update existing gauge
            local gauge = existingRow.gauge
            gauge:move(0, yPos)
            gauge:resize("100%", rowHeight .. "px")
            gauge:setValue(gaugeValue, 100, labelText)
            
            -- Update colors
            GUI.AbilityGaugeBackCSS:set("background-color", colors.back)
            GUI.AbilityGaugeBackCSS:set("border", "1px solid " .. colors.back)
            gauge.back:setStyleSheet(GUI.AbilityGaugeBackCSS:getCSS())
            GUI.AbilityGaugeFrontCSS:set("background-color", colors.front)
            gauge.front:setStyleSheet(GUI.AbilityGaugeFrontCSS:getCSS())
            
            -- Update stored info in case order changed
            GUI.AbilityRows[i].id = abilityInfo.id
            GUI.AbilityRows[i].name = name
            
            -- Update click callback with current ability name
            -- Note: Gauge doesn't have setClickCallback, use the front label
            local abilityName = name
            gauge.front:setClickCallback(function()
                send(abilityName)
            end)
            
            gauge:show()
        else
            -- Debug: echo("[RefreshDisplay] Creating NEW gauge\n")
            -- Create new gauge with error handling
            local success, err = pcall(function()
                local gauge = Geyser.Gauge:new({
                    name = "GUI.AbilityGauge" .. i,
                    x = 0, y = yPos,
                    width = "100%", height = rowHeight .. "px"
                }, GUI.AbilitiesListContainer)
                
                -- Debug: echo("[RefreshDisplay] Gauge object created\n")
                
                -- Apply styles
                GUI.AbilityGaugeBackCSS:set("background-color", colors.back)
                GUI.AbilityGaugeBackCSS:set("border", "1px solid " .. colors.back)
                gauge.back:setStyleSheet(GUI.AbilityGaugeBackCSS:getCSS())
                GUI.AbilityGaugeFrontCSS:set("background-color", colors.front)
                gauge.front:setStyleSheet(GUI.AbilityGaugeFrontCSS:getCSS())
                
                -- Debug: echo("[RefreshDisplay] Styles applied\n")
                
                gauge:setValue(gaugeValue, 100, labelText)
                
                -- Debug: echo("[RefreshDisplay] Value set\n")
                
                -- Store the ability name for the click callback
                -- Note: Gauge doesn't have setClickCallback, use the front label
                local abilityName = name
                gauge.front:setClickCallback(function()
                    send(abilityName)
                end)
                
                gauge:show()
                
                -- Debug: echo("[RefreshDisplay] About to store in AbilityRows\n")
                
                GUI.AbilityRows[i] = {
                    gauge = gauge,
                    id = abilityInfo.id,
                    name = name
                }
                -- Debug: echo("[RefreshDisplay] Created gauge at index " .. i .. ", AbilityRows count now: " .. #GUI.AbilityRows .. "\n")
            end)
            
            if not success then
                -- Debug: echo("[RefreshDisplay] ERROR creating gauge: " .. tostring(err) .. "\n")
            end
        end
    end
end

-- Function to add an ability (keyed by monitor ID)
function AddAbility(name, monitorData)
    local id = monitorData and monitorData.id or nil
    if not id then
        -- No monitor ID provided, cannot track this ability
        return
    end
    
    -- Reset retry state since we received an ability
    ResetAbilitiesRetryState()
    
    local expires = monitorData.expires or 0
    local warn = monitorData.warn or 0
    
    GUI.ActiveAbilities[id] = {
        name = name,
        expires = expires,
        remaining = expires,
        warn = warn,
        startTime = os.time()
    }
    
    -- Kill any existing timer for this monitor ID
    if GUI.AbilityTimers[id] then
        killTimer(GUI.AbilityTimers[id])
        GUI.AbilityTimers[id] = nil
    end
    
    -- Start countdown timer if ability has an expiry
    if expires and expires > 0 then
        GUI.AbilityTimers[id] = tempTimer(1, function()
            UpdateAbilityTimer(id)
        end, true)  -- repeating timer
    end
    
    RefreshAbilitiesDisplay()
end

-- Function to update ability timer countdown (by monitor ID)
function UpdateAbilityTimer(monitorId)
    if not GUI.ActiveAbilities[monitorId] then
        -- Ability was removed, kill timer
        if GUI.AbilityTimers[monitorId] then
            killTimer(GUI.AbilityTimers[monitorId])
            GUI.AbilityTimers[monitorId] = nil
        end
        return
    end
    
    local ability = GUI.ActiveAbilities[monitorId]
    
    -- Decrement remaining time
    if ability.remaining and ability.remaining > 0 then
        ability.remaining = ability.remaining - 1
        RefreshAbilitiesDisplay()
    end
    
    -- If time expired, the server should send a Remove message
    -- but we can also handle it here as a fallback
    if ability.remaining and ability.remaining <= 0 then
        if GUI.AbilityTimers[monitorId] then
            killTimer(GUI.AbilityTimers[monitorId])
            GUI.AbilityTimers[monitorId] = nil
        end
    end
end

-- Function to remove an ability (by monitor ID)
function RemoveAbility(name, monitorId)
    -- Debug: echo("\n[RemoveAbility] Called with name=" .. tostring(name) .. ", id=" .. tostring(monitorId) .. "\n")
    
    if not monitorId then
        -- Debug: echo("[RemoveAbility] No monitor ID provided\n")
        return
    end
    
    -- Check if ability exists
    if not GUI.ActiveAbilities[monitorId] then
        -- Debug: echo("[RemoveAbility] Ability not found in GUI.ActiveAbilities\n")
        -- Debug: local keys = {}
        -- Debug: for k, _ in pairs(GUI.ActiveAbilities) do table.insert(keys, k) end
        -- Debug: echo("[RemoveAbility] Active abilities: " .. table.concat(keys, ", ") .. "\n")
        return
    end
    
    -- Debug: echo("[RemoveAbility] Found ability, removing...\n")
    
    -- Kill timer if exists
    if GUI.AbilityTimers[monitorId] then
        killTimer(GUI.AbilityTimers[monitorId])
        GUI.AbilityTimers[monitorId] = nil
    end
    
    -- Remove from active abilities
    GUI.ActiveAbilities[monitorId] = nil
    
    -- Hide all existing gauges first (they'll be recreated/shown in RefreshAbilitiesDisplay)
    for i, row in pairs(GUI.AbilityRows) do
        if row and row.gauge then
            row.gauge:hide()
        end
    end
    
    RefreshAbilitiesDisplay()
end

-- Function to update ability warning state (by monitor ID)
function UpdateAbilityWarning(name, monitorId, warn)
    if not monitorId then
        return
    end
    
    if GUI.ActiveAbilities[monitorId] then
        GUI.ActiveAbilities[monitorId].warn = warn
        RefreshAbilitiesDisplay()
    end
end
-- Function to clear all abilities (called on disconnect)
function ClearAllAbilities()
    -- Kill all timers
    if GUI.AbilityTimers then
        for id, timerId in pairs(GUI.AbilityTimers) do
            killTimer(timerId)
        end
    end
    GUI.AbilityTimers = {}
    
    -- Clear active abilities
    GUI.ActiveAbilities = {}
    
    -- Hide all gauges from our tracked rows
    if GUI.AbilityRows then
        for i, row in pairs(GUI.AbilityRows) do
            if row and row.gauge and row.gauge.hide then
                row.gauge:hide()
            end
        end
    end
    GUI.AbilityRows = {}
    
    -- Fallback: search Geyser.windowList for any ability gauges we may have lost track of
    if Geyser and Geyser.windowList then
        for windowName, windowObj in pairs(Geyser.windowList) do
            -- Check if this is one of our ability gauges (matches "GUI.AbilityGauge" prefix)
            if type(windowName) == "string" and windowName:find("^GUI%.AbilityGauge%d+") then
                if windowObj and windowObj.hide then
                    windowObj:hide()
                end
            end
        end
    end
end

-- Retry state for abilities refresh (preserved across reloads)
GUI.AbilitiesRetryCount = GUI.AbilitiesRetryCount or 0
GUI.AbilitiesMaxRetries = 5  -- Stop after this many attempts
GUI.AbilitiesBaseInterval = 10  -- Base interval in seconds
GUI.AbilitiesCurrentInterval = GUI.AbilitiesCurrentInterval or GUI.AbilitiesBaseInterval

-- Function to reset retry state (call when abilities arrive)
function ResetAbilitiesRetryState()
    GUI.AbilitiesRetryCount = 0
    GUI.AbilitiesCurrentInterval = GUI.AbilitiesBaseInterval
end

-- Function to check if abilities list is empty and request from server
function CheckAbilitiesAndRefresh()
    -- Check if abilities list is empty using idiomatic Lua
    if next(GUI.ActiveAbilities) ~= nil then
        -- Abilities exist, reset retry state and skip
        ResetAbilitiesRetryState()
        return
    end
    
    -- Connection guard: only send GMCP if connected
    -- Check multiple possible connection indicators
    local isConnected = (GUI and GUI.isConnected) or 
                        (gmcp and gmcp.Char) or 
                        (getNetworkLatency and getNetworkLatency() > 0)
    
    if not isConnected then
        -- Not connected, skip this check
        return
    end
    
    -- Check retry limit
    if GUI.AbilitiesRetryCount >= GUI.AbilitiesMaxRetries then
        -- Max retries reached, stop trying
        return
    end
    
    -- Increment retry counter and send request
    GUI.AbilitiesRetryCount = GUI.AbilitiesRetryCount + 1
    sendGMCP("Char.Abilities.List")
    
    -- Exponential backoff: double the interval after each attempt (cap at 5 minutes)
    GUI.AbilitiesCurrentInterval = math.min(GUI.AbilitiesCurrentInterval * 2, 300)
end

-- Kill existing abilities check timer if it exists
if GUI.AbilitiesCheckTimer then
    killTimer(GUI.AbilitiesCheckTimer)
    GUI.AbilitiesCheckTimer = nil
end

-- Function to schedule next abilities check with current interval
function ScheduleAbilitiesCheck()
    if GUI.AbilitiesCheckTimer then
        killTimer(GUI.AbilitiesCheckTimer)
    end
    GUI.AbilitiesCheckTimer = tempTimer(GUI.AbilitiesCurrentInterval, function()
        CheckAbilitiesAndRefresh()
        ScheduleAbilitiesCheck()  -- Schedule next check
    end)
end

-- Start the periodic check
ScheduleAbilitiesCheck()