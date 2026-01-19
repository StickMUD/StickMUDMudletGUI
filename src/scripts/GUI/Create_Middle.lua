-- CSS for the left panel
GUI.BoxLeftCSS = CSSMan.new([[
    background-color: rgba(0,0,0,255);
    qproperty-wordWrap: true;
]])

-- Title label for Abilities
GUI.AbilitiesTitle = Geyser.Label:new({
    name = "GUI.AbilitiesTitle",
    x = 0, y = 0,
    width = "100%",
    height = "24px"
}, GUI.Middle)

GUI.AbilitiesTitle:setStyleSheet([[
    background-color: rgba(30,30,35,255);
    border-bottom: 1px solid rgba(80,80,90,255);
]])
GUI.AbilitiesTitle:echo([[<center><font size="3" color="#888">⚡ Abilities</font></center>]])

-- ScrollBox for abilities list
GUI.AbilitiesScrollBox = Geyser.ScrollBox:new({
    name = "GUI.AbilitiesScrollBox",
    x = 0, y = "24px",
    width = "100%",
    height = "-24px"
}, GUI.Middle)

-- Create background container inside scrollbox (following GamePlayersList pattern)
GUI.AbilitiesListContainer = Geyser.Label:new({
    name = "GUI.AbilitiesListContainer",
    x = 0, y = 0,
    width = "100%", height = "100%"
}, GUI.AbilitiesScrollBox)
GUI.AbilitiesListContainer:setStyleSheet([[background-color: rgba(0,0,0,255);]])

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
    -- Get sorted list of abilities (sort by name for consistent display)
    local sortedAbilities = {}
    for id, ability in pairs(GUI.ActiveAbilities) do
        table.insert(sortedAbilities, {id = id, name = ability.name, data = ability})
    end
    table.sort(sortedAbilities, function(a, b) return a.name < b.name end)
    
    -- Debug: echo("[RefreshDisplay] Active abilities count: " .. #sortedAbilities .. ", GUI.AbilityRows count: " .. #GUI.AbilityRows .. "\n")
    
    -- Calculate row height
    local rowHeight = 36
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
    local yPos = 0
    for i, abilityInfo in ipairs(sortedAbilities) do
        -- Debug: echo("[RefreshDisplay] Processing ability " .. i .. ": " .. abilityInfo.name .. "\n")
        local ability = abilityInfo.data
        local name = abilityInfo.name
        local colors = getAbilityColor(ability.remaining, ability.warn, name)
        
        -- Calculate gauge value (100% if no expiry, percentage if expiring)
        local gaugeValue = 100
        if ability.expires and ability.expires > 0 and ability.remaining then
            gaugeValue = math.max(0, math.min(100, (ability.remaining / ability.expires) * 100))
        end
        
        -- Format the label text (just the ability name, time shown via gauge fill)
        local labelText = string.format(
            [[<center><font size="4" color="white"><b>%s</b></font></center>]],
            firstToUpper(name)
        )
        
        local existingRow = GUI.AbilityRows[i]
        -- Debug: echo("[RefreshDisplay] Checking existing row: " .. tostring(existingRow ~= nil) .. ", gauge: " .. tostring(existingRow and existingRow.gauge ~= nil) .. "\n")
        
        if existingRow and existingRow.gauge then
            -- Debug: echo("[RefreshDisplay] Updating existing gauge\n")
            -- Update existing gauge
            local gauge = existingRow.gauge
            gauge:move(0, yPos .. "px")
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
                    x = 0, y = yPos .. "px",
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
        
        yPos = yPos + rowHeight
    end
end

-- Function to add an ability (keyed by monitor ID)
function AddAbility(name, monitorData)
    local id = monitorData and monitorData.id or nil
    if not id then
        -- No monitor ID provided, cannot track this ability
        return
    end
    
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