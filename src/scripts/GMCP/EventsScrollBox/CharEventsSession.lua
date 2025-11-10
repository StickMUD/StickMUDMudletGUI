-- Handler for Char.Events.Session GMCP package
-- Displays player's current event session data

-- Store the current event session data
eventsSessionData = eventsSessionData or {}

function CharEventsSession(event, gmcp_data)
    -- Parse the GMCP data
    local data = gmcp_data and yajl.to_value(gmcp_data) or gmcp.Char.Events.Session
    
    if not data then
        return
    end
    
    -- Store the session data
    eventsSessionData = data
    
    -- Rebuild the events display if EventsScrollBox is currently visible
    if GUI.EventsScrollBox and GUI.EventsScrollBox:isHidden() == false then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Char.Events.Session", "CharEventsSession")
