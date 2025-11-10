-- Handler for Game.Events.Start GMCP package
-- Notifies when a new event begins

function GameEventsStart(event, gmcp_data)
    -- Parse the GMCP data
    local data = gmcp_data and yajl.to_value(gmcp_data) or gmcp.Game.Events.Start
    
    if not data then
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
    
    -- Rebuild the events display if EventsScrollBox is currently visible
    if GUI.EventsScrollBox and GUI.EventsScrollBox:isHidden() == false then
        CharEventsList()
    end
    
    -- Optional: Display notification that event started
    cecho("\n<yellow>Event Started: <white>" .. data.event_name .. "\n")
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.Start", "GameEventsStart")
