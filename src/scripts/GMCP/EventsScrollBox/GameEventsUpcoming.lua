-- Handler for Game.Events.Upcoming GMCP package
-- Lists all upcoming events sorted by start time

-- Initialize upcoming events storage
upcomingEvents = upcomingEvents or {}

function GameEventsUpcoming(event, gmcp_data)
    -- Get the data from gmcp table
    local data = gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Upcoming
    
    -- If no data available, clear upcoming events and return
    if not data or type(data) ~= "table" then
        upcomingEvents = {}
        return
    end
    
    -- Clear and rebuild upcoming events list
    upcomingEvents = {}
    
    for _, event_data in ipairs(data) do
        if event_data.event_id then
            table.insert(upcomingEvents, {
                event_id = event_data.event_id,
                event_name = event_data.event_name,
                event_type = event_data.event_type,
                start_time = event_data.start_time,
                end_time = event_data.end_time,
                description = event_data.description
            })
        end
    end
    
    -- Sort by start_time in ascending order
    table.sort(upcomingEvents, function(a, b)
        return a.start_time < b.start_time
    end)
    
    -- Only rebuild the display if EventsScrollBox is currently selected
    if selected_console == "EventsScrollBox" then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.Upcoming", "GameEventsUpcoming")
