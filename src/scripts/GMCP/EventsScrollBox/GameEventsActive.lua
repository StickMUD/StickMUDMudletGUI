-- Handler for Game.Events.Active GMCP package
-- Lists all currently active events

-- Initialize active events storage
activeEvents = activeEvents or {}

function GameEventsActive(event, gmcp_data)
    -- Get the data from gmcp table
    local data = gmcp.Game and gmcp.Game.Events and gmcp.Game.Events.Active
    
    -- If no data available, clear active events and return
    if not data or type(data) ~= "table" then
        activeEvents = {}
        return
    end
    
    -- Clear and rebuild active events list
    activeEvents = {}
    
    for _, event_data in ipairs(data) do
        if event_data.event_id then
            activeEvents[event_data.event_id] = {
                event_id = event_data.event_id,
                event_name = event_data.event_name,
                event_type = event_data.event_type,
                start_time = event_data.start_time,
                end_time = event_data.end_time
            }
        end
    end
    
    -- Only rebuild the display if EventsScrollBox is currently selected
    if selected_console == "EventsScrollBox" then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.Active", "GameEventsActive")
