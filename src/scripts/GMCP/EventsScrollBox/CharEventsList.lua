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
    -- If end_time is 0, the event has no end time (ongoing/permanent)
    if endTime == 0 then
        return "<green>Ongoing</green>"
    end
    
    local now = os.time()
    local remaining = endTime - now
    
    if remaining <= 0 then
        return "<red>Ended</red>", true  -- Return true to indicate event ended
    end
    
    local hours = math.floor(remaining / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60
    
    if hours > 0 then
        return string.format("<yellow>%dh %dm %ds remaining</yellow>", hours, minutes, seconds), false
    elseif minutes > 0 then
        return string.format("<yellow>%dm %ds remaining</yellow>", minutes, seconds), false
    else
        return string.format("<yellow>%ds remaining</yellow>", seconds), false
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
        -- Display each active event
        for eventId, eventData in pairs(activeEvents) do
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
            if eventsSessionData and eventsSessionData.event_id == eventId then
                eventsList = eventsList .. "<br>"
                eventsList = eventsList .. string.format(
                    "<font size=\"%d\" color=\"white\"><b>Your Progress:</b></font><br>",
                    eventsCurrentFontSize
                )
                
                -- Display summary stats
                if eventsSessionData.areas_completed and eventsSessionData.areas_total then
                    local progress_pct = math.floor((eventsSessionData.areas_completed / eventsSessionData.areas_total) * 100)
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Areas: </font><font size=\"%d\" color=\"yellow\">%d/%d</font> <font size=\"%d\" color=\"cyan\">(%d%%)</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, 
                        eventsSessionData.areas_completed, eventsSessionData.areas_total,
                        eventsCurrentFontSize, progress_pct
                    )
                end
                
                if eventsSessionData.rank then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Rank: </font><font size=\"%d\" color=\"green\">#%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, eventsSessionData.rank
                    )
                end
                
                if eventsSessionData.kills then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Kills: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, eventsSessionData.kills
                    )
                end
                
                if eventsSessionData.points then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Points: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, eventsSessionData.points
                    )
                end
                
                -- Display detailed area progress if available
                if eventsSessionData.progress and type(eventsSessionData.progress) == "table" then
                    eventsList = eventsList .. "<br>"
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"white\"><b>Area Progress:</b></font><br>",
                        eventsCurrentFontSize
                    )
                    
                    -- Count completed and in-progress areas
                    local completed_areas = {}
                    local in_progress_areas = {}
                    
                    for _, area in ipairs(eventsSessionData.progress) do
                        if area.completed == 1 then
                            table.insert(completed_areas, area)
                        elseif area.bosses_killed > 0 or (area.bosses_total and area.bosses_total > 0) then
                            table.insert(in_progress_areas, area)
                        end
                    end
                    
                    -- Sort areas by name
                    table.sort(completed_areas, function(a, b) return a.area_name < b.area_name end)
                    table.sort(in_progress_areas, function(a, b) return a.area_name < b.area_name end)
                    
                    -- Show completed areas
                    if #completed_areas > 0 then
                        eventsList = eventsList .. string.format(
                            "<font size=\"%d\" color=\"green\">✓ Completed (%d):</font><br>",
                            eventsCurrentFontSize, #completed_areas
                        )
                        for _, area in ipairs(completed_areas) do
                            local bosses_killed = area.bosses_killed or 0
                            local bosses_total = area.bosses_total or 0
                            
                            eventsList = eventsList .. "<tr><td width=\"100%\">"
                            eventsList = eventsList .. string.format(
                                "<font size=\"%d\" color=\"gray\">  %s</font>",
                                eventsCurrentFontSize - 1, area.area_name
                            )
                            -- Show boss counts
                            if bosses_killed > 0 or bosses_total > 0 then
                                eventsList = eventsList .. string.format(
                                    " <font size=\"%d\" color=\"yellow\">(%d / %d)</font>",
                                    eventsCurrentFontSize - 1, bosses_killed, bosses_total
                                )
                            end
                            eventsList = eventsList .. "</td></tr>"
                        end
                    end
                    
                    -- Show in-progress areas
                    if #in_progress_areas > 0 then
                        if #completed_areas > 0 then
                            eventsList = eventsList .. "<tr><td width=\"100%\"><br></td></tr>"
                        end
                        eventsList = eventsList .. string.format(
                            "<tr><td width=\"100%%\"><font size=\"%d\" color=\"yellow\">◐ In Progress (%d):</font></td></tr>",
                            eventsCurrentFontSize, #in_progress_areas
                        )
                        for _, area in ipairs(in_progress_areas) do
                            eventsList = eventsList .. "<tr><td width=\"100%\">"
                            eventsList = eventsList .. string.format(
                                "  <a href=\"send:goto %s\"><font size=\"%d\">%s</font></a>",
                                area.area_name, eventsCurrentFontSize - 1, area.area_name
                            )
                            eventsList = eventsList .. string.format(
                                " <font size=\"%d\" color=\"yellow\">(%d / %d)</font>",
                                eventsCurrentFontSize - 1, area.bosses_killed, area.bosses_total
                            )
                            eventsList = eventsList .. "</td></tr>"
                        end
                    end
                end
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
        height = "400%"
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
    
    -- Check if we need a countdown timer (any active event with non-zero end_time)
    local needsCountdown = false
    for _, eventData in pairs(activeEvents) do
        if eventData.end_time and eventData.end_time > 0 and eventData.end_time > os.time() then
            needsCountdown = true
            break
        end
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
    height = "400%"
}, GUI.EventsScrollBox)

GUI.CharEventsListLabel:setStyleSheet(getEventsListCSS(eventsCurrentFontSize):getCSS())
setBackgroundColor("GUI.CharEventsListLabel", 0, 0, 0)
-- setLinkStyle("GUI.CharEventsListLabel", "cyan", "blue", true) -- Uncomment after Mudlet 4.20 release
GUI.CharEventsListLabel:echo("<table><tr><td><center><font size=\"" .. eventsCurrentFontSize .. "\" color=\"gray\">Click to load events...</font></center></td></tr></table>")
