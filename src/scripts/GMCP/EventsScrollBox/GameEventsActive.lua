-- Handler for Game.Events.Active GMCP package
-- Lists all currently active events

-- Initialize active events storage
activeEvents = activeEvents or {}

function GameEventsActive(event, gmcp_data)
    -- Parse the GMCP data
    local data = gmcp_data and yajl.to_value(gmcp_data) or gmcp.Game.Events.Active
    
    if not data then
        return
    end
    
    -- Clear and rebuild active events list
    activeEvents = {}
    
    if type(data) == "table" then
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
    end
    
    -- Rebuild the events display if EventsScrollBox is currently visible
    if GUI.EventsScrollBox and GUI.EventsScrollBox:isHidden() == false then
        CharEventsList()
    end
end

-- Register the event handler
registerAnonymousEventHandler("gmcp.Game.Events.Active", "GameEventsActive")
