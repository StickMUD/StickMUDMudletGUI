-- Initialize font size for the events list
local eventsCurrentFontSize = content_preferences["GUI.EventsScrollBox"].fontSize
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

    -- Main container (HBox) to hold the "+" and "-" buttons
    GUI.EventsHBox = Geyser.Label:new({
        name = "GUI.EventsHBox",
        x = 0,
        y = 0,
        width = "100%",
        height = "25px"
    }, GUI.EventsBackgroundLabel)

    -- Container to hold the title
    GUI.EventsTitleContainer = Geyser.Container:new({
        name = "GUI.EventsTitleContainer",
        x = "5px",
        y = 0,
        width = "calc(100% - 60px)",
        height = "100%"
    }, GUI.EventsHBox)

    -- Title label
    GUI.EventsTitleLabel = Geyser.Label:new({
        name = "GUI.EventsTitleLabel",
        x = 0,
        y = 0,
        width = "100%",
        height = "100%"
    }, GUI.EventsTitleContainer)

    GUI.EventsTitleLabel:echo("<center>Active Events</center>")
    GUI.EventsTitleLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(0,0,0,0);
            color: white;
            font-weight: bold;
        }
    ]])

    -- Container for the "+" and "-" buttons
    GUI.EventsButtonsContainer = Geyser.Container:new({
        name = "GUI.EventsButtonsContainer",
        x = "calc(100% - 55px)",
        y = 0,
        width = "50px",
        height = "100%"
    }, GUI.EventsHBox)

    -- Plus button
    GUI.EventsPlusLabel = Geyser.Label:new({
        name = "GUI.EventsPlusLabel",
        x = 0,
        y = 0,
        width = "50%",
        height = "100%"
    }, GUI.EventsButtonsContainer)

    GUI.EventsPlusLabel:echo("<center><b>+</b></center>")
    GUI.EventsPlusLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(60,60,60,255);
            border: 1px solid rgba(100,100,100,255);
            color: white;
        }
        QLabel:hover{
            background-color: rgba(80,80,80,255);
        }
    ]])
    GUI.EventsPlusLabel:setClickCallback(function()
        adjustFontSizeEventsList(1)
    end)

    -- Minus button
    GUI.EventsMinusLabel = Geyser.Label:new({
        name = "GUI.EventsMinusLabel",
        x = "50%",
        y = 0,
        width = "50%",
        height = "100%"
    }, GUI.EventsButtonsContainer)

    GUI.EventsMinusLabel:echo("<center><b>-</b></center>")
    GUI.EventsMinusLabel:setStyleSheet([[
        QLabel{
            background-color: rgba(60,60,60,255);
            border: 1px solid rgba(100,100,100,255);
            color: white;
        }
        QLabel:hover{
            background-color: rgba(80,80,80,255);
        }
    ]])
    GUI.EventsMinusLabel:setClickCallback(function()
        adjustFontSizeEventsList(-1)
    end)
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
    -- Check if GUI.EventsScrollBox exists before trying to update
    if not GUI or not GUI.EventsScrollBox then
        return
    end
    
    -- Initialize the active events table if it doesn't exist
    activeEvents = activeEvents or {}
    eventsSessionData = eventsSessionData or {}

    -- Clear existing content
    if GUI.EventsVBox then
        GUI.EventsVBox:hide()
        GUI.EventsVBox = nil
    end

    -- Create the font adjustment panel if it doesn't exist
    if not GUI.EventsBackgroundLabel then
        createFontAdjustmentPanelForEvents()
    end

    -- Create the main VBox container for events
    GUI.EventsVBox = Geyser.VBox:new({
        name = "GUI.EventsVBox",
        x = 0,
        y = "30px",
        width = "100%",
        height = "calc(100% - 30px)"
    }, GUI.EventsScrollBox)

    local eventsCSS = getEventsListCSS(eventsCurrentFontSize)

    -- Check if there are any active events
    local hasActiveEvents = false
    for _ in pairs(activeEvents) do
        hasActiveEvents = true
        break
    end

    if not hasActiveEvents then
        -- Display "No active events" message
        local noEventsLabel = Geyser.Label:new({
            name = "GUI.NoEventsLabel",
            x = 0,
            y = 0,
            width = "100%",
            height = "100%"
        }, GUI.EventsVBox)

        noEventsLabel:setStyleSheet(eventsCSS:getCSS())
        noEventsLabel:echo("<center><dim>No active events</dim></center>")
    else
        -- Display each active event
        for eventId, eventData in pairs(activeEvents) do
            local eventContainer = Geyser.Container:new({
                name = "GUI.Event_" .. eventId,
                width = "100%",
                height = "auto"
            }, GUI.EventsVBox)

            local eventLabel = Geyser.Label:new({
                name = "GUI.EventLabel_" .. eventId,
                x = "5px",
                y = 0,
                width = "calc(100% - 10px)",
                height = "100%"
            }, eventContainer)

            -- Build the event display text
            local displayText = string.format(
                "<white><b>%s</b></white>\n" ..
                "<dim>Type:</dim> <cyan>%s</cyan>\n" ..
                "%s\n",
                eventData.event_name,
                getEventTypeName(eventData.event_type),
                formatTimeRemaining(eventData.end_time)
            )

            -- Add session data if available for this event
            if eventsSessionData and eventsSessionData.event_id == eventId then
                displayText = displayText .. "\n<white><b>Your Progress:</b></white>\n"
                
                -- Display session data based on what's available
                if eventsSessionData.rank then
                    displayText = displayText .. string.format("<dim>Rank:</dim> <green>#%d</green>\n", eventsSessionData.rank)
                end
                
                if eventsSessionData.kills then
                    displayText = displayText .. string.format("<dim>Kills:</dim> <yellow>%d</yellow>\n", eventsSessionData.kills)
                end
                
                if eventsSessionData.points then
                    displayText = displayText .. string.format("<dim>Points:</dim> <yellow>%d</yellow>\n", eventsSessionData.points)
                end
                
                if eventsSessionData.total_bosses then
                    displayText = displayText .. string.format("<dim>Bosses Killed:</dim> <yellow>%d</yellow>\n", eventsSessionData.total_bosses)
                end
                
                if eventsSessionData.areas_completed then
                    displayText = displayText .. string.format("<dim>Areas Completed:</dim> <yellow>%d</yellow>\n", eventsSessionData.areas_completed)
                end
            end

            displayText = displayText .. "\n<dim>" .. string.rep("─", 50) .. "</dim>\n"

            eventLabel:setStyleSheet(eventsCSS:getCSS())
            eventLabel:echo(displayText)
        end
    end

    GUI.EventsVBox:show()
end
