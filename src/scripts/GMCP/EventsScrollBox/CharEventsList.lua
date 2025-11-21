-- Initialize font size for the events list
local eventsCurrentFontSize = content_preferences["GUI.EventsScrollBox"] and content_preferences["GUI.EventsScrollBox"].fontSize or 12
local eventsMinFontSize = 1 -- Minimum allowed font size

-- Timer for updating the events list countdown
local eventsCountdownTimer = nil

-- Define the CSS for the events list display with dynamic font size
function getEventsListCSS(fontSize)
    return CSSMan.new([[
        qproperty-wordWrap: true;
        qproperty-alignment: 'AlignTop';
        font-size: ]] .. fontSize .. [[px;
    ]])
end

-- Function to adjust the font size of the events list
function adjustFontSizeEventsList(adjustment)
    eventsCurrentFontSize = eventsCurrentFontSize + adjustment
    if eventsCurrentFontSize < eventsMinFontSize then
        eventsCurrentFontSize = eventsMinFontSize
    end
    -- Update preferences and save
    content_preferences["GUI.EventsScrollBox"].fontSize = eventsCurrentFontSize
    table.save(content_preferences_file, content_preferences)
    CharEventsList() -- Rebuild the events list with the updated font size
end

-- Creates the font adjustment panel with "+" and "-" buttons
function createFontAdjustmentPanelForEvents()
    -- Background label for the adjustment panel
    GUI.EventsBackgroundLabel = Geyser.Label:new({
        name = "GUI.EventsBackgroundLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.EventsScrollBox)

    -- Set the background color for the panel
    GUI.EventsBackgroundLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(0,0,0,255);
        }
    ]])

    -- Title label (takes up most of the space)
    GUI.EventsTitleLabel = Geyser.Label:new({
        name = "GUI.EventsTitleLabel",
        x = 0,
        y = 0,
        width = "80%",
        height = "25px"
    }, GUI.EventsBackgroundLabel)

    GUI.EventsTitleLabel:echo("<center>Active Events</center>")
    GUI.EventsTitleLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(0,0,0,0);
            color: white;
            font-weight: bold;
        }
    ]])

    -- Plus button
    GUI.EventsPlusLabel = Geyser.Label:new({
        name = "GUI.EventsPlusLabel",
        x = "80%",
        y = 0,
        width = "10%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"green\">+</font></center>"
    }, GUI.EventsBackgroundLabel)

    GUI.EventsPlusLabel:setClickCallback(function()
        adjustFontSizeEventsList(1)
    end)

    GUI.EventsPlusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])

    -- Minus button
    GUI.EventsMinusLabel = Geyser.Label:new({
        name = "GUI.EventsMinusLabel",
        x = "90%",
        y = 0,
        width = "10%",
        height = "25px",
        message = "<center><font size=\"4\" color=\"red\">-</font></center>"
    }, GUI.EventsBackgroundLabel)

    GUI.EventsMinusLabel:setClickCallback(function()
        adjustFontSizeEventsList(-1)
    end)

    GUI.EventsMinusLabel:setStyleSheet([[
        background-color: rgba(0,0,0,255);
        border-style: solid;
        border-width: 1px;
        text-align: center;
    ]])
end

-- Helper function to format time remaining
local function formatTimeRemaining(endTime)
    -- If end_time is nil or 0, the event has no end time (ongoing/permanent)
    if not endTime or endTime == 0 then
        return "<font color=\"lime\">Ongoing</font>"
    end
    
    local now = os.time()
    local remaining = endTime - now
    
    if remaining <= 0 then
        return "<font color=\"red\">Ended</font>", true  -- Return true to indicate event ended
    end
    
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60
    
    if days > 0 then
        return string.format("<font color=\"yellow\">%d</font><font color=\"white\">d</font> <font color=\"yellow\">%d</font><font color=\"white\">h</font> <font color=\"yellow\">%d</font><font color=\"white\">m remaining</font>", days, hours, minutes), false
    elseif hours > 0 then
        return string.format("<font color=\"yellow\">%d</font><font color=\"white\">h</font> <font color=\"yellow\">%d</font><font color=\"white\">m</font> <font color=\"yellow\">%d</font><font color=\"white\">s remaining</font>", hours, minutes, seconds), false
    elseif minutes > 0 then
        return string.format("<font color=\"yellow\">%d</font><font color=\"white\">m</font> <font color=\"yellow\">%d</font><font color=\"white\">s remaining</font>", minutes, seconds), false
    else
        return string.format("<font color=\"yellow\">%d</font><font color=\"white\">s remaining</font>", seconds), false
    end
end

-- Helper function to format time until event starts
local function formatTimeUntilStart(startTime)
    if not startTime or startTime == 0 then
        return "<font color=\"gray\">Unknown</font>"
    end
    
    local now = os.time()
    local remaining = startTime - now
    
    if remaining <= 0 then
        return "<font color=\"lime\">Starting now!</font>"
    end
    
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60
    
    if days > 0 then
        return string.format("<font color=\"cyan\">Starts in</font> <font color=\"yellow\">%dd</font> <font color=\"yellow\">%dh</font> <font color=\"yellow\">%dm</font>", days, hours, minutes)
    elseif hours > 0 then
        return string.format("<font color=\"cyan\">Starts in</font> <font color=\"yellow\">%dh</font> <font color=\"yellow\">%dm</font> <font color=\"yellow\">%ds</font>", hours, minutes, seconds)
    elseif minutes > 0 then
        return string.format("<font color=\"cyan\">Starts in</font> <font color=\"yellow\">%dm</font> <font color=\"yellow\">%ds</font>", minutes, seconds)
    else
        return string.format("<font color=\"cyan\">Starts in</font> <font color=\"yellow\">%ds</font>", seconds)
    end
end

-- Helper function to get event type name
local function getEventTypeName(eventType)
    local types = {
        [1] = "Passive Enhancement",
        [2] = "Competitive Kill",
        [3] = "Competitive Collect",
        [4] = "Sequential",
        [5] = "Race",
        [6] = "Meta Event"
    }
    return types[eventType] or "Unknown"
end

-- Helper function to check if event type is competitive collect
-- Also checks event_id as fallback when event_type is missing or 0
local function isCompetitiveCollect(eventType, eventId)
    if eventType == 3 then
        return true
    end
    
    -- Fallback: detect collection events by their event_id
    -- when event_type is missing or unknown
    if eventId then
        local collectEventIds = {
            "CAPTURETHECLOVER",
            "CAPTURETHEFLAG",
            "EASTEREGGHUNT",
            "DELIVERTHEPACKAGE"
        }
        for _, collectId in ipairs(collectEventIds) do
            if eventId == collectId then
                return true
            end
        end
    end
    
    return false
end

-- Helper function to get collection field name for an area
local function getCollectionFieldValue(area)
    -- Check for collection-specific fields in order of likelihood
    return area.clovers_captured 
        or area.packages_delivered 
        or area.eggs_found 
        or area.flags_captured 
        or area.mascots_killed 
        or area.bosses_killed 
        or 0
end

-- Helper function to get collection field name for display
local function getCollectionFieldName(area)
    if area.clovers_captured then return "clovers", area.clovers_captured end
    if area.packages_delivered then return "packages", area.packages_delivered end
    if area.eggs_found then return "eggs", area.eggs_found end
    if area.flags_captured then return "flags", area.flags_captured end
    if area.mascots_killed then return "mascots", area.mascots_killed end
    if area.bosses_killed then return "bosses", area.bosses_killed end
    return nil, 0
end

-- Helper function to detect if area has kill event progress data
local function hasKillEventData(area)
    return area.has_werewolves ~= nil or area.werewolves_remaining ~= nil or area.werewolf_rank ~= nil
end

-- Helper function to get enemy name based on event_id
local function getEnemyName(eventId, plural)
    local enemies = {
        WEREWOLFAPOC = plural and "wolves" or "wolf",
        ZOMBIEAPOC = plural and "zombies" or "zombie",
        TURKEYAPOC = plural and "turkeys" or "turkey",
        TROOPERAPOC = plural and "troopers" or "trooper"
    }
    return enemies[eventId] or (plural and "enemies" or "enemy")
end

-- Helper function to get difficulty color for kill events
local function getDifficultyColor(rank)
    local colors = {
        mini = "gray",
        legendary = "yellow",
        epic = "orange",
        ultimate = "red"
    }
    return colors[rank] or "white"
end

-- Helper function to get difficulty rank value for sorting
local function getDifficultyRank(rank)
    local ranks = {
        mini = 1,
        legendary = 2,
        epic = 3,
        ultimate = 4
    }
    return ranks[rank] or 0
end

-- Main function to display the events list
function CharEventsList()
    -- Clear visited link states when refreshing the events list (available in Mudlet 4.20+)
    --if GUI.CharEventsListLabel then
    --    clearVisitedLinks("GUI.CharEventsListLabel")
    --end

    -- Initialize the active events table if it doesn't exist
    activeEvents = activeEvents or {}
    eventsSessionData = eventsSessionData or {}
    
    -- Refresh active events from GMCP data to ensure we have the latest
    if gmcp and gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Active and type(gmcp.Game.Events.Active) == "table" then
        activeEvents = {}
        for _, event_data in ipairs(gmcp.Game.Events.Active) do
            if event_data.id then
                activeEvents[event_data.id] = {
                    event_id = event_data.id,
                    event_name = event_data.name,
                    event_type = event_data.type,
                    start_time = event_data.start_time,
                    end_time = event_data.end_time
                }
            end
        end
    end
    
    -- Also check gmcp.Char.Events.Session for session data (alternative location)
    -- As of server update, this is now an ARRAY of session objects (one per active event)
    if gmcp and gmcp.Char and gmcp.Char.Events and gmcp.Char.Events.Session then
        local charEventSessions = gmcp.Char.Events.Session
        -- Handle both old format (single object) and new format (array)
        if type(charEventSessions) == "table" then
            -- Check if it's an array (new format) or single object (old format)
            if charEventSessions[1] or #charEventSessions > 0 then
                -- New array format - store for later lookup by event_id
                eventsSessionData = charEventSessions
            elseif charEventSessions.event_id then
                -- Old single object format - wrap in array for consistency
                eventsSessionData = {charEventSessions}
            end
            
            -- Also add any events from session data to activeEvents if not already present
            -- This handles cases where Game.Events.Active might not include all events with session data
            for _, session in ipairs(eventsSessionData) do
                if session.event_id and not activeEvents[session.event_id] then
                    -- Try to get additional event info from Game.Events.Active first
                    local eventInfo = nil
                    if gmcp and gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Active then
                        for _, evt in ipairs(gmcp.Game.Events.Active) do
                            if evt.id == session.event_id then
                                eventInfo = evt
                                break
                            end
                        end
                    end
                    
                    -- If not found in Active, check Game.Events.List
                    if not eventInfo and gmcp and gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.List then
                        for _, evt in ipairs(gmcp.Game.Events.List) do
                            if evt.id == session.event_id then
                                eventInfo = evt
                                break
                            end
                        end
                    end
                    
                    -- Create event entry with whatever data we have
                    activeEvents[session.event_id] = {
                        event_id = session.event_id,
                        event_name = session.event_name or (eventInfo and eventInfo.name) or session.event_id,
                        event_type = eventInfo and eventInfo.type or 0,
                        start_time = eventInfo and eventInfo.start_time or 0,
                        end_time = eventInfo and eventInfo.end_time or 0
                    }
                end
            end
        end
    end

    -- Create the font adjustment panel if it doesn't exist
    if not GUI.EventsBackgroundLabel then
        createFontAdjustmentPanelForEvents()
    end

    -- Build the HTML content
    local eventsList = "<table width=\"100%\">"
    
    -- Check if there are any active events
    local hasActiveEvents = false
    for _ in pairs(activeEvents) do
        hasActiveEvents = true
        break
    end

    if not hasActiveEvents then
        eventsList = eventsList .. "<tr><td><center><font size=\"" .. eventsCurrentFontSize .. "\" color=\"gray\">No active events</font></center></td></tr>"
    else
        -- Convert activeEvents table to sorted array
        local sortedEvents = {}
        for eventId, eventData in pairs(activeEvents) do
            table.insert(sortedEvents, eventData)
        end
        
        -- Sort events: those with end_time > 0 first (by nearest end_time), then others
        table.sort(sortedEvents, function(a, b)
            local aHasEndTime = a.end_time and a.end_time > 0
            local bHasEndTime = b.end_time and b.end_time > 0
            
            -- Both have end times - sort by nearest first
            if aHasEndTime and bHasEndTime then
                return a.end_time < b.end_time
            end
            
            -- Only a has end time - a comes first
            if aHasEndTime then
                return true
            end
            
            -- Only b has end time - b comes first
            if bHasEndTime then
                return false
            end
            
            -- Neither has end time - maintain alphabetical order by name
            return a.event_name < b.event_name
        end)
        
        -- Display each active event in sorted order
        for _, eventData in ipairs(sortedEvents) do
            local eventId = eventData.event_id
            eventsList = eventsList .. "<tr><td>"
            
            -- Event name and type
            eventsList = eventsList .. string.format(
                "<font size=\"%d\" color=\"white\"><b>%s</b></font><br>",
                eventsCurrentFontSize + 1,
                eventData.event_name
            )
            
            eventsList = eventsList .. string.format(
                "<font size=\"%d\" color=\"gray\">Type: </font><font size=\"%d\" color=\"cyan\">%s</font><br>",
                eventsCurrentFontSize,
                eventsCurrentFontSize,
                getEventTypeName(eventData.event_type)
            )
            
            -- Time remaining
            local timeText, hasEnded = formatTimeRemaining(eventData.end_time)
            eventsList = eventsList .. string.format(
                "<font size=\"%d\">%s</font><br>",
                eventsCurrentFontSize,
                timeText
            )

            -- Add session data if available for this event
            -- Match by event_id or by event_name (fallback for events that use different ID formats)
            local sessionMatches = false
            local currentSessionData = nil
            
            -- First, check if this event has session data embedded in Game.Events.Active
            if gmcp and gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Active then
                for _, activeEvent in ipairs(gmcp.Game.Events.Active) do
                    if activeEvent.id == eventId and activeEvent.session then
                        currentSessionData = activeEvent.session
                        sessionMatches = true
                        break
                    end
                end
            end
            
            -- Fallback to Char.Events.Session if not found in Active
            -- Note: eventsSessionData is now an array of session objects
            if not sessionMatches and eventsSessionData and type(eventsSessionData) == "table" then
                -- Search through the array of sessions
                for _, session in ipairs(eventsSessionData) do
                    if session.event_id == eventId then
                        currentSessionData = session
                        sessionMatches = true
                        break
                    elseif session.event_name and session.event_name == eventData.event_name then
                        currentSessionData = session
                        sessionMatches = true
                        break
                    end
                end
            end
            
            if sessionMatches and currentSessionData then
                eventsList = eventsList .. "<br>"
                eventsList = eventsList .. string.format(
                    "<font size=\"%d\" color=\"white\"><b>Your Progress:</b></font><br>",
                    eventsCurrentFontSize
                )
                
                -- Display summary stats
                if currentSessionData.areas_completed and currentSessionData.areas_total then
                    local progress_pct = math.floor((currentSessionData.areas_completed / currentSessionData.areas_total) * 100)
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Areas: </font><font size=\"%d\" color=\"yellow\">%d/%d</font> <font size=\"%d\" color=\"cyan\">(%d%%)</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, 
                        currentSessionData.areas_completed, currentSessionData.areas_total,
                        eventsCurrentFontSize, progress_pct
                    )
                end
                
                if currentSessionData.rank then
                    local totalParticipants = currentSessionData.total_participants or 0
                    if totalParticipants > 0 then
                        eventsList = eventsList .. string.format(
                            "<font size=\"%d\" color=\"gray\">Rank: </font><font size=\"%d\" color=\"green\">#%d</font><font size=\"%d\" color=\"gray\"> / %d</font><br>",
                            eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.rank,
                            eventsCurrentFontSize, totalParticipants
                        )
                    else
                        eventsList = eventsList .. string.format(
                            "<font size=\"%d\" color=\"gray\">Rank: </font><font size=\"%d\" color=\"green\">#%d</font><br>",
                            eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.rank
                        )
                    end
                end
                
                if currentSessionData.kills then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Kills: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.kills
                    )
                end
                
                -- Display clover-specific fields
                if currentSessionData.clovers then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Clovers Captured: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.clovers
                    )
                end
                
                if currentSessionData.four_leaf_clovers and currentSessionData.four_leaf_clovers > 0 then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Four Leaf Clovers: </font><font size=\"%d\" color=\"green\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.four_leaf_clovers
                    )
                end
                
                -- Display flag-specific fields
                if currentSessionData.white_flags then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">White Flags: </font><font size=\"%d\" color=\"white\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.white_flags
                    )
                end
                
                if currentSessionData.blue_flags and currentSessionData.blue_flags > 0 then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Blue Flags: </font><font size=\"%d\" color=\"cyan\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.blue_flags
                    )
                end
                
                if currentSessionData.red_flags and currentSessionData.red_flags > 0 then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Red Flags: </font><font size=\"%d\" color=\"red\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.red_flags
                    )
                end
                
                if currentSessionData.points then
                    local pointsLabel = "Points"
                    -- For Competitive Collect events, points represent collected items
                    if isCompetitiveCollect(eventData.event_type, eventData.event_id) then
                        pointsLabel = "Items Collected"
                    end
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">%s: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, pointsLabel, eventsCurrentFontSize, currentSessionData.points
                    )
                end
                
                -- Display kill event summary stats
                if currentSessionData.areas_total and currentSessionData.areas_cleared then
                    local total = currentSessionData.areas_total
                    local cleared = currentSessionData.areas_cleared
                    local percent = total > 0 and math.floor((cleared / total) * 100) or 0
                    
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Areas: </font><font size=\"%d\" color=\"yellow\">%d/%d</font><font size=\"%d\" color=\"gray\"> (%d%% cleared)</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, cleared, total, eventsCurrentFontSize, percent
                    )
                end
                
                if currentSessionData.areas_with_werewolves and currentSessionData.areas_with_werewolves > 0 then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Active Combat: </font><font size=\"%d\" color=\"yellow\">%d areas</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, currentSessionData.areas_with_werewolves
                    )
                end
                
                -- Display detailed area progress if available
                if currentSessionData.progress and type(currentSessionData.progress) == "table" then
                    eventsList = eventsList .. "<br>"
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"white\"><b>Area Progress:</b></font>",
                        eventsCurrentFontSize
                    )
                    eventsList = eventsList .. "<br>"
                    
                    -- Count completed and in-progress areas
                    local completed_areas = {}
                    local in_progress_areas = {}
                    local active_combat_areas = {}
                    local cleared_areas = {}
                    local available_areas = {}
                    
                    -- Detect if this is a kill event with new progress data
                    local isKillEvent = currentSessionData.progress[1] and hasKillEventData(currentSessionData.progress[1])
                    
                    for _, area in ipairs(currentSessionData.progress) do
                        if isKillEvent then
                            -- New kill event data structure
                            if area.cleared == 1 then
                                -- Area fully cleared - all enemies dead
                                table.insert(cleared_areas, area)
                            elseif area.has_werewolves == 1 and (area.werewolves_remaining or 0) > 0 then
                                -- Area has active enemies to fight
                                table.insert(active_combat_areas, area)
                            elseif area.has_werewolves == 1 and (area.werewolves_remaining or 0) == 0 then
                                -- Area announced but all enemies killed (transitioning to cleared)
                                table.insert(cleared_areas, area)
                            end
                        else
                            -- Legacy collection/kill event data structure
                            if area.completed == 1 then
                                table.insert(completed_areas, area)
                            else
                                -- Check for any collection activity
                                local collection_value = getCollectionFieldValue(area)
                                local total_value = area.bosses_total or 0
                                
                                -- For Kill events: show if bosses_total > 0 (available bosses to kill)
                                -- For Collect events: show all incomplete areas (where collection is possible)
                                if isCompetitiveCollect(eventData.event_type, eventData.event_id) then
                                    -- Collect events: show all areas that aren't completed
                                    -- (all areas are collectable until marked complete)
                                    table.insert(in_progress_areas, area)
                                else
                                    -- Kill events: show areas with bosses to kill OR already started
                                    if total_value > 0 or collection_value > 0 then
                                        table.insert(in_progress_areas, area)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Sort areas
                    if isKillEvent then
                        -- Sort active combat by difficulty (ultimate first) then alphabetically
                        table.sort(active_combat_areas, function(a, b)
                            local rankA = getDifficultyRank(a.werewolf_rank)
                            local rankB = getDifficultyRank(b.werewolf_rank)
                            if rankA ~= rankB then
                                return rankA > rankB  -- Higher difficulty first
                            end
                            return a.area_name < b.area_name
                        end)
                        table.sort(cleared_areas, function(a, b) return a.area_name < b.area_name end)
                    else
                        -- Sort legacy areas by name
                        table.sort(completed_areas, function(a, b) return a.area_name < b.area_name end)
                        table.sort(in_progress_areas, function(a, b) return a.area_name < b.area_name end)
                    end
                    
                    -- Show active combat areas for kill events
                    if isKillEvent and #active_combat_areas > 0 then
                        local enemyName = getEnemyName(eventData.event_id, true)
                        eventsList = eventsList .. string.format(
                            "<tr><td width=\"100%%\"><font size=\"%d\" color=\"yellow\">⚔️ Active Combat (%d):</font></td></tr>",
                            eventsCurrentFontSize, #active_combat_areas
                        )
                        for _, area in ipairs(active_combat_areas) do
                            local remaining = area.werewolves_remaining or 0
                            local rank = area.werewolf_rank or ""
                            local rankColor = getDifficultyColor(rank)
                            local rankText = rank ~= "" and rank .. " " or ""
                            
                            eventsList = eventsList .. "<tr><td width=\"100%\">"
                            eventsList = eventsList .. string.format(
                                "  <a href=\"send:goto %s\"><font size=\"%d\">%s</font></a>",
                                area.area_name, eventsCurrentFontSize - 1, area.area_name
                            )
                            eventsList = eventsList .. string.format(
                                " <font size=\"%d\" color=\"%s\">(%d %s%s)</font>",
                                eventsCurrentFontSize - 1, rankColor, remaining, rankText, enemyName
                            )
                            eventsList = eventsList .. "</td></tr>"
                        end
                    end
                    
                    -- Show in-progress areas first (more important) - legacy format
                    if not isKillEvent and #in_progress_areas > 0 then
                        -- Use event-type-specific label
                        local inProgressLabel = isCompetitiveCollect(eventData.event_type, eventData.event_id) and "Collecting" or "In Progress"
                        eventsList = eventsList .. string.format(
                            "<tr><td width=\"100%%\"><font size=\"%d\" color=\"yellow\">◐ %s (%d):</font></td></tr>",
                            eventsCurrentFontSize, inProgressLabel, #in_progress_areas
                        )
                        for _, area in ipairs(in_progress_areas) do
                            eventsList = eventsList .. "<tr><td width=\"100%\">"
                            eventsList = eventsList .. string.format(
                                "  <a href=\"send:goto %s\"><font size=\"%d\">%s</font></a>",
                                area.area_name, eventsCurrentFontSize - 1, area.area_name
                            )
                            
                            -- Display appropriate progress indicator
                            local field_name, field_value = getCollectionFieldName(area)
                            if field_name == "bosses" then
                                local bosses_total = area.bosses_total or 0
                                eventsList = eventsList .. string.format(
                                    " <font size=\"%d\" color=\"yellow\">(%d / %d)</font>",
                                    eventsCurrentFontSize - 1, field_value, bosses_total
                                )
                            elseif field_name and field_value > 0 then
                                -- For collection events, show details if available instead of just count
                                local details = {}
                                
                                -- Capture the Clover: four_leaf field (0 or 1)
                                if area.four_leaf and area.four_leaf == 1 then
                                    table.insert(details, "4-leaf")
                                end
                                
                                -- Easter Egg Hunt: egg_type field (string or 0)
                                if area.egg_type and area.egg_type ~= 0 and area.egg_type ~= "" then
                                    table.insert(details, area.egg_type .. " egg")
                                end
                                
                                -- Capture the Flag: flag_color field (string)
                                if area.flag_color and area.flag_color ~= 0 and area.flag_color ~= "" then
                                    table.insert(details, area.flag_color .. " flag")
                                end
                                
                                -- Deliver the Package: package_type and to_npc fields
                                if area.package_type and area.package_type ~= 0 and area.package_type ~= "" then
                                    local package_desc = area.package_type .. " package"
                                    if area.to_npc and area.to_npc == 1 then
                                        package_desc = package_desc .. " to NPC"
                                    end
                                    table.insert(details, package_desc)
                                end
                                
                                if #details > 0 then
                                    eventsList = eventsList .. string.format(
                                        " <font size=\"%d\" color=\"yellow\">(%s)</font>",
                                        eventsCurrentFontSize - 1, table.concat(details, ", ")
                                    )
                                end
                            end
                            eventsList = eventsList .. "</td></tr>"
                        end
                    end
                    
                    -- Show cleared areas for kill events
                    if isKillEvent and #cleared_areas > 0 then
                        if #active_combat_areas > 0 then
                            eventsList = eventsList .. "<tr><td width=\"100%\">&nbsp;</td></tr>"
                        end
                        eventsList = eventsList .. "<tr><td width=\"100%\">"
                        eventsList = eventsList .. string.format(
                            "<font size=\"%d\" color=\"green\">✓ Cleared (%d):</font>",
                            eventsCurrentFontSize, #cleared_areas
                        )
                        eventsList = eventsList .. "</td></tr>"
                        for _, area in ipairs(cleared_areas) do
                            eventsList = eventsList .. "<tr><td width=\"100%\">"
                            eventsList = eventsList .. string.format(
                                "<font size=\"%d\" color=\"gray\">  %s</font>",
                                eventsCurrentFontSize - 1, area.area_name
                            )
                            eventsList = eventsList .. "</td></tr>"
                        end
                    end
                    
                    -- Show completed areas below in-progress - legacy format
                    if not isKillEvent and #completed_areas > 0 then
                        if #in_progress_areas > 0 then
                            eventsList = eventsList .. "<tr><td width=\"100%\">&nbsp;</td></tr>"
                        end
                        eventsList = eventsList .. "<tr><td width=\"100%\">"
                        eventsList = eventsList .. string.format(
                            "<font size=\"%d\" color=\"green\">✓ Completed (%d):</font>",
                            eventsCurrentFontSize, #completed_areas
                        )
                        eventsList = eventsList .. "</td></tr>"
                        for _, area in ipairs(completed_areas) do
                            eventsList = eventsList .. "<tr><td width=\"100%\">"
                            eventsList = eventsList .. string.format(
                                "<font size=\"%d\" color=\"gray\">  %s</font>",
                                eventsCurrentFontSize - 1, area.area_name
                            )
                            
                            -- Show collection details for completed areas
                            local field_name, field_value = getCollectionFieldName(area)
                            if field_name == "bosses" then
                                local bosses_total = area.bosses_total or 0
                                if field_value > 0 or bosses_total > 0 then
                                    eventsList = eventsList .. string.format(
                                        " <font size=\"%d\" color=\"yellow\">(%d / %d)</font>",
                                        eventsCurrentFontSize - 1, field_value, bosses_total
                                    )
                                end
                            elseif field_name and field_value > 0 then
                                -- For collection events, show details if available instead of just count
                                local details = {}
                                
                                -- Capture the Clover: four_leaf field (0 or 1)
                                if area.four_leaf and area.four_leaf == 1 then
                                    table.insert(details, "4-leaf")
                                end
                                
                                -- Easter Egg Hunt: egg_type field (string or 0)
                                if area.egg_type and area.egg_type ~= 0 and area.egg_type ~= "" then
                                    table.insert(details, area.egg_type .. " egg")
                                end
                                
                                -- Capture the Flag: flag_color field (string)
                                if area.flag_color and area.flag_color ~= 0 and area.flag_color ~= "" then
                                    table.insert(details, area.flag_color .. " flag")
                                end
                                
                                -- Deliver the Package: package_type and to_npc fields
                                if area.package_type and area.package_type ~= 0 and area.package_type ~= "" then
                                    local package_desc = area.package_type .. " package"
                                    if area.to_npc and area.to_npc == 1 then
                                        package_desc = package_desc .. " to NPC"
                                    end
                                    table.insert(details, package_desc)
                                end
                                
                                if #details > 0 then
                                    eventsList = eventsList .. string.format(
                                        " <font size=\"%d\" color=\"yellow\">(%s)</font>",
                                        eventsCurrentFontSize - 1, table.concat(details, ", ")
                                    )
                                end
                            end
                            eventsList = eventsList .. "</td></tr>"
                        end
                    end
                end
            end

            eventsList = eventsList .. "<br><font size=\"" .. eventsCurrentFontSize .. "\" color=\"gray\">" .. string.rep("─", 50) .. "</font><br>"
            eventsList = eventsList .. "</td></tr>"
        end
    end

    -- Display upcoming events if any exist
    upcomingEvents = upcomingEvents or {}
    
    -- Also refresh from GMCP data if available
    if gmcp and gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Upcoming and type(gmcp.Game.Events.Upcoming) == "table" then
        upcomingEvents = {}
        for _, event_data in ipairs(gmcp.Game.Events.Upcoming) do
            if event_data.event_id then
                table.insert(upcomingEvents, {
                    event_id = event_data.event_id,
                    event_name = event_data.event_name,
                    event_type = event_data.event_type,
                    start_time = event_data.start_time,
                    end_time = event_data.end_time,
                    description = event_data.description
                })
            end
        end
        
        -- Sort by start_time in ascending order
        table.sort(upcomingEvents, function(a, b)
            return a.start_time < b.start_time
        end)
    end
    
    if #upcomingEvents > 0 then
        -- Display each upcoming event
        for _, eventData in ipairs(upcomingEvents) do
            eventsList = eventsList .. "<tr><td>"
            
            -- Event name
            eventsList = eventsList .. string.format(
                "<font size=\"%d\" color=\"white\"><b>%s</b></font><br>",
                eventsCurrentFontSize + 1,
                eventData.event_name
            )
            
            -- Event type
            eventsList = eventsList .. string.format(
                "<font size=\"%d\" color=\"gray\">Type: </font><font size=\"%d\" color=\"cyan\">%s</font><br>",
                eventsCurrentFontSize,
                eventsCurrentFontSize,
                getEventTypeName(eventData.event_type)
            )
            
            -- Time until start
            local timeUntilStartText = formatTimeUntilStart(eventData.start_time)
            eventsList = eventsList .. string.format(
                "<font size=\"%d\">%s</font><br>",
                eventsCurrentFontSize,
                timeUntilStartText
            )
            
            -- Description if available
            if eventData.description and eventData.description ~= "" then
                eventsList = eventsList .. string.format(
                    "<font size=\"%d\" color=\"gray\">%s</font><br>",
                    eventsCurrentFontSize - 1,
                    eventData.description
                )
            end
            
            eventsList = eventsList .. "<br><font size=\"" .. eventsCurrentFontSize .. "\" color=\"gray\">" .. string.rep("─", 50) .. "</font><br>"
            eventsList = eventsList .. "</td></tr>"
        end
    end

    eventsList = eventsList .. "</table>"

    -- Display the events list in the GUI
    GUI.CharEventsListLabel = GUI.CharEventsListLabel or Geyser.Label:new({
        name = "GUI.CharEventsListLabel",
        x = 0,
        y = "25px",
        width = "100%",
        height = "2000%"
    }, GUI.EventsScrollBox)

    GUI.CharEventsListLabel:setStyleSheet(getEventsListCSS(eventsCurrentFontSize):getCSS())
    setBackgroundColor("GUI.CharEventsListLabel", 0, 0, 0)
    --setLinkStyle("GUI.CharEventsListLabel", "cyan", "blue", true)   -- Uncomment after Mudlet 4.20 release
    GUI.CharEventsListLabel:echo(eventsList)
    
    -- Set up countdown timer if there are active events with end times
    if eventsCountdownTimer then
        killTimer(eventsCountdownTimer)
        eventsCountdownTimer = nil
    end
    
    -- Check if we need a countdown timer (any active event with non-zero end_time or any upcoming events)
    local needsCountdown = false
    for _, eventData in pairs(activeEvents) do
        if eventData.end_time and eventData.end_time > 0 and eventData.end_time > os.time() then
            needsCountdown = true
            break
        end
    end
    
    -- Also check if there are upcoming events
    if not needsCountdown and upcomingEvents and #upcomingEvents > 0 then
        needsCountdown = true
    end
    
    -- Start a timer to update the countdown every second
    if needsCountdown then
        eventsCountdownTimer = tempTimer(1, function()
            CharEventsList()
        end, true)  -- true means repeating timer
    end
end

-- Initialize the font adjustment panel and create the display label
createFontAdjustmentPanelForEvents()

-- Create the display label with initial placeholder
GUI.CharEventsListLabel = Geyser.Label:new({
    name = "GUI.CharEventsListLabel",
    x = 0,
    y = "25px",
    width = "100%",
    height = "2000%"
}, GUI.EventsScrollBox)

GUI.CharEventsListLabel:setStyleSheet(getEventsListCSS(eventsCurrentFontSize):getCSS())
setBackgroundColor("GUI.CharEventsListLabel", 0, 0, 0)
-- setLinkStyle("GUI.CharEventsListLabel", "cyan", "blue", true) -- Uncomment after Mudlet 4.20 release
GUI.CharEventsListLabel:echo("<table><tr><td><center><font size=\"" .. eventsCurrentFontSize .. "\" color=\"gray\">Click to load events...</font></center></td></tr></table>")
