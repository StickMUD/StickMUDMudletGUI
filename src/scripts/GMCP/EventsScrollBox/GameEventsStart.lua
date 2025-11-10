-- Handler for Game.Events.Start GMCP package
-- Notifies when a new event begins

function GameEventsStart(event, gmcp_data)
    -- Get the data from gmcp table
    local data = gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Start
    
    if not data or type(data) ~= "table" then
        return
    end
    
    -- Store in active events list
    activeEvents = activeEvents or {}
    activeEvents[data.event_id] = {
        event_id = data.event_id,
        event_name = data.event_name,
        event_type = data.event_type,
        start_time = data.start_time,
        end_time = data.end_time
    }
    
    -- Only rebuild the display if EventsScrollBox is currently selected
    if selected_console == "EventsScrollBox" then
        CharEventsList()
    end
    
    -- Optional: Display notification that event started
    cecho("\n<yellow>Event Started: <white>" .. data.event_name .. "\n")
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.Start", "GameEventsStart")
