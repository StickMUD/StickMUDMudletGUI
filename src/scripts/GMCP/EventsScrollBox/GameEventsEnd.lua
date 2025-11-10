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
    if activeEvents[data.id] then
        activeEvents[data.id] = nil
    end
    
    -- Clear session data for this event
    if eventsSessionData and eventsSessionData.event_id == data.id then
        eventsSessionData = {}
    end
    
    -- Only rebuild the display if EventsScrollBox is currently selected
    if selected_console == "EventsScrollBox" then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.End", "GameEventsEnd")
