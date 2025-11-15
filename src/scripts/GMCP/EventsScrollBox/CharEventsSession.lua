-- Handler for Char.Events.Session GMCP package
-- Displays player's current event session data

-- Store the current event session data
eventsSessionData = eventsSessionData or {}

function CharEventsSession(event, gmcp_data)
    -- Get the data from gmcp table
    local data = gmcp.Char and gmcp.Char.Events and gmcp.Char.Events.Session
    
    if not data or type(data) ~= "table" then
        eventsSessionData = {}
        return
    end
    
    -- Store the session data
    eventsSessionData = data
    
    -- Only rebuild the display if EventsScrollBox is currently selected
    if selected_console == "EventsScrollBox" then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Char.Events.Session", "CharEventsSession")
