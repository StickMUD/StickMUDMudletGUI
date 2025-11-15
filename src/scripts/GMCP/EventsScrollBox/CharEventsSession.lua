-- Handler for Char.Events.Session GMCP package
-- Displays player's current event session data

-- Store the current event session data
eventsSessionData = eventsSessionData or {}

function CharEventsSession(event, gmcp_data)
    -- Get the data from gmcp table
    local data = gmcp.Char and gmcp.Char.Events and gmcp.Char.Events.Session
    
    if not data or type(data) ~= "table" then
        eventsSessionData = {}
        cecho("\n<red>DEBUG CharEventsSession: No data or not a table</red>")
        return
    end
    
    -- Store the session data
    eventsSessionData = data
    
    -- Debug output
    cecho(string.format("\n<green>DEBUG CharEventsSession: Received event_id '%s'</green>", tostring(data.event_id)))
    if data.areas_completed and data.areas_total then
        cecho(string.format("\n<green>DEBUG CharEventsSession: Areas %d/%d</green>", data.areas_completed, data.areas_total))
    end
    if data.progress then
        cecho(string.format("\n<green>DEBUG CharEventsSession: Progress table has %d areas</green>", #data.progress))
    end
    
    -- Only rebuild the display if EventsScrollBox is currently selected
    if selected_console == "EventsScrollBox" then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Char.Events.Session", "CharEventsSession")
