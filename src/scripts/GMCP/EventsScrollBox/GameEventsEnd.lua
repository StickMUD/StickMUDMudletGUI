-- Handler for Game.Events.End GMCP package
-- Notifies when an event ends

function GameEventsEnd(event, gmcp_data)
    -- Get the data from gmcp table
    local data = gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.End
    
    if not data or type(data) ~= "table" then
        return
    end
    
    -- Remove from active events list
    activeEvents = activeEvents or {}
    if activeEvents[data.event_id] then
        activeEvents[data.event_id] = nil
    end
    
    -- Clear session data for this event
    if eventsSessionData and eventsSessionData.event_id == data.event_id then
        eventsSessionData = {}
    end
    
    -- Rebuild the events display
    CharEventsList()
    
    -- Optional: Display notification that event ended
    cecho("\n<yellow>Event Ended: <white>" .. data.event_name .. "\n")
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.End", "GameEventsEnd")
