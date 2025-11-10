-- Initialize font size for the events list
local eventsCurrentFontSize = content_preferences["GUI.EventsScrollBox"] and content_preferences["GUI.EventsScrollBox"].fontSize or 12
local eventsMinFontSize = 1 -- Minimum allowed font size

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
    local now = os.time()
    local remaining = endTime - now
    
    if remaining <= 0 then
        return "<red>Ended</red>"
    end
    
    local hours = math.floor(remaining / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    
    if hours > 0 then
        return string.format("<yellow>%dh %dm remaining</yellow>", hours, minutes)
    else
        return string.format("<yellow>%dm remaining</yellow>", minutes)
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
    -- Initialize the active events table if it doesn't exist
    activeEvents = activeEvents or {}
    eventsSessionData = eventsSessionData or {}

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
            local timeText = formatTimeRemaining(eventData.end_time)
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
                
                if eventsSessionData.total_bosses then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Bosses: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, eventsSessionData.total_bosses
                    )
                end
                
                if eventsSessionData.areas_completed then
                    eventsList = eventsList .. string.format(
                        "<font size=\"%d\" color=\"gray\">Areas: </font><font size=\"%d\" color=\"yellow\">%d</font><br>",
                        eventsCurrentFontSize, eventsCurrentFontSize, eventsSessionData.areas_completed
                    )
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
    GUI.CharEventsListLabel:echo(eventsList)
end

-- Initialize the font adjustment panel and events list
createFontAdjustmentPanelForEvents()
CharEventsList()
