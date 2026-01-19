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
}, GUI.Left)

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
}, GUI.Left)

-- Create background container inside scrollbox (following GamePlayersList pattern)
GUI.AbilitiesListContainer = Geyser.Label:new({
    name = "GUI.AbilitiesListContainer",
    x = 0, y = 0,
    width = "100%", height = "100%"
}, GUI.AbilitiesScrollBox)
GUI.AbilitiesListContainer:setStyleSheet([[background-color: rgba(0,0,0,255);]])

-- Storage for active abilities and their UI elements
-- Reset on script load to ensure clean state with new GUI elements
GUI.ActiveAbilities = {}
GUI.AbilityRows = {}
-- Kill any existing timers before resetting
if GUI.AbilityTimers then
    for name, timerId in pairs(GUI.AbilityTimers) do
        killTimer(timerId)
    end
end
GUI.AbilityTimers = {}

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
    active = {front = "#27ae60", back = "#0d3d1a"},      -- Green for active
    warning = {front = "#f39c12", back = "#4d3205"},    -- Orange for warning
    expiring = {front = "#e74c3c", back = "#4a1a15"}    -- Red for expiring soon
}

-- Helper function to get ability color based on remaining time
function getAbilityColor(expires, warn)
    if warn == 1 then
        return GUI.AbilityColors.warning
    elseif expires and expires > 0 and expires <= 30 then
        return GUI.AbilityColors.expiring
    else
        return GUI.AbilityColors.active
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
    -- Get sorted list of ability names
    local sortedNames = {}
    for name, _ in pairs(GUI.ActiveAbilities) do
        table.insert(sortedNames, name)
    end
    table.sort(sortedNames)
    
    -- Calculate row height
    local rowHeight = 36
    local totalHeight = #sortedNames * rowHeight
    
    -- Hide any extra rows from previous render
    for i = #sortedNames + 1, #GUI.AbilityRows do
        if GUI.AbilityRows[i] and GUI.AbilityRows[i].gauge then
            GUI.AbilityRows[i].gauge:hide()
        end
    end
    
    -- Create or update rows for each ability
    local yPos = 0
    for i, name in ipairs(sortedNames) do
        local ability = GUI.ActiveAbilities[name]
        local colors = getAbilityColor(ability.remaining, ability.warn)
        
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
        
        if GUI.AbilityRows[i] and GUI.AbilityRows[i].gauge then
            -- Update existing gauge
            local gauge = GUI.AbilityRows[i].gauge
            gauge:move(0, yPos .. "px")
            gauge:resize("100%", rowHeight .. "px")
            gauge:setValue(gaugeValue, 100, labelText)
            
            -- Update colors
            GUI.AbilityGaugeBackCSS:set("background-color", colors.back)
            GUI.AbilityGaugeBackCSS:set("border", "1px solid " .. colors.back)
            gauge.back:setStyleSheet(GUI.AbilityGaugeBackCSS:getCSS())
            GUI.AbilityGaugeFrontCSS:set("background-color", colors.front)
            gauge.front:setStyleSheet(GUI.AbilityGaugeFrontCSS:getCSS())
            
            -- Update stored name in case order changed
            GUI.AbilityRows[i].name = name
            gauge:show()
        else
            -- Create new gauge
            local gauge = Geyser.Gauge:new({
                name = "GUI.AbilityGauge" .. i,
                x = 0, y = yPos .. "px",
                width = "100%", height = rowHeight .. "px"
            }, GUI.AbilitiesListContainer)
            
            -- Apply styles
            GUI.AbilityGaugeBackCSS:set("background-color", colors.back)
            GUI.AbilityGaugeBackCSS:set("border", "1px solid " .. colors.back)
            gauge.back:setStyleSheet(GUI.AbilityGaugeBackCSS:getCSS())
            GUI.AbilityGaugeFrontCSS:set("background-color", colors.front)
            gauge.front:setStyleSheet(GUI.AbilityGaugeFrontCSS:getCSS())
            
            gauge:setValue(gaugeValue, 100, labelText)
            
            -- Store the ability name for the click callback
            local abilityName = name
            gauge:setClickCallback(function()
                send(abilityName)
            end)
            
            gauge:show()
            
            GUI.AbilityRows[i] = {
                gauge = gauge,
                name = name
            }
        end
        
        yPos = yPos + rowHeight
    end
end

-- Function to add an ability
function AddAbility(name, monitorData)
    local expires = monitorData and monitorData.expires or 0
    local warn = monitorData and monitorData.warn or 0
    local id = monitorData and monitorData.id or nil
    
    GUI.ActiveAbilities[name] = {
        id = id,
        expires = expires,
        remaining = expires,
        warn = warn,
        startTime = os.time()
    }
    
    -- Kill any existing timer for this ability
    if GUI.AbilityTimers[name] then
        killTimer(GUI.AbilityTimers[name])
        GUI.AbilityTimers[name] = nil
    end
    
    -- Start countdown timer if ability has an expiry
    if expires and expires > 0 then
        GUI.AbilityTimers[name] = tempTimer(1, function()
            UpdateAbilityTimer(name)
        end, true)  -- repeating timer
    end
    
    RefreshAbilitiesDisplay()
end

-- Function to update ability timer countdown
function UpdateAbilityTimer(name)
    if not GUI.ActiveAbilities[name] then
        -- Ability was removed, kill timer
        if GUI.AbilityTimers[name] then
            killTimer(GUI.AbilityTimers[name])
            GUI.AbilityTimers[name] = nil
        end
        return
    end
    
    local ability = GUI.ActiveAbilities[name]
    
    -- Decrement remaining time
    if ability.remaining and ability.remaining > 0 then
        ability.remaining = ability.remaining - 1
        RefreshAbilitiesDisplay()
    end
    
    -- If time expired, the server should send a Remove message
    -- but we can also handle it here as a fallback
    if ability.remaining and ability.remaining <= 0 then
        if GUI.AbilityTimers[name] then
            killTimer(GUI.AbilityTimers[name])
            GUI.AbilityTimers[name] = nil
        end
    end
end

-- Function to remove an ability
function RemoveAbility(name, monitorId)
    -- Kill timer if exists
    if GUI.AbilityTimers[name] then
        killTimer(GUI.AbilityTimers[name])
        GUI.AbilityTimers[name] = nil
    end
    
    -- Remove from active abilities
    GUI.ActiveAbilities[name] = nil
    
    -- Hide all existing gauges first (they'll be recreated/shown in RefreshAbilitiesDisplay)
    for i, row in ipairs(GUI.AbilityRows) do
        if row and row.gauge then
            row.gauge:hide()
        end
    end
    
    RefreshAbilitiesDisplay()
end

-- Function to update ability warning state
function UpdateAbilityWarning(name, warn)
    if GUI.ActiveAbilities[name] then
        GUI.ActiveAbilities[name].warn = warn
        RefreshAbilitiesDisplay()
    end
end
