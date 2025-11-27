function CommChannelText()
    -- Check if GMCP Comm.Channel.Text data is available
    if not gmcp or not gmcp.Comm or not gmcp.Comm.Channel or not gmcp.Comm.Channel.Text then
        return
    end
    
    local channel = gmcp.Comm.Channel.Text.channel
    local text = gmcp.Comm.Channel.Text.text
    
    -- Exit if channel or text is missing
    if not channel or not text then
        return
    end
    
    local timeStamp = os.date("%I:%M ")

    -- Fallback function to get preferences safely
    local function getPreference(consoleName, key, defaultValue)
        if content_preferences[consoleName] and
            content_preferences[consoleName][key] ~= nil then
            return content_preferences[consoleName][key]
        end
        return defaultValue
    end

    -- Function to handle the output to a specific console
    local function outputToConsole(consoleName)
        local linefeed = getPreference(consoleName, "doublespace", true) and
                             "\n\n" or "\n"

        if getPreference(consoleName, "timestamp", true) then
            cecho(consoleName,
                  "<yellow:black>" .. timeStamp .. "<cyan:black>" .. text ..
                      linefeed)
        else
            cecho(consoleName, "<cyan:black>" .. text .. linefeed)
        end
    end

    -- Output to the general chat console
    outputToConsole("GUI.ChatAllConsole")

    -- Define the channel to console mapping
    local channelConsoleMap = {
        ["Tell"] = "GUI.ChatTellsConsole",
        ["Local"] = "GUI.ChatLocalConsole",
        ["Clan"] = "GUI.ChatClanConsole"
        -- Add more channels as necessary
    }

    -- Check for specific channels
    if string.match(channel, "^&") then
        -- Special channel handling for "&"
        outputToConsole("GUI.ChatClanConsole")
    elseif channelConsoleMap[channel] then
        -- Standard channel mapping
        outputToConsole(channelConsoleMap[channel])
    else
        -- Guild channels dynamic mapping
        local guildChannels = {
            ["bard"] = true,
            ["bardleaders"] = true,
            ["fighter"] = true,
            ["fighterofc"] = true,
            ["healer"] = true,
            ["healerchief"] = true,
            ["mage"] = true,
            ["magecouncil"] = true,
            ["necro"] = true,
            ["necrocouncil"] = true,
            ["ninja"] = true,
            ["ninjakanbu"] = true,
            ["priest"] = true,
            ["priestofc"] = true,
            ["thief"] = true,
            ["thiefarc"] = true,
            ["thiefdmn"] = true,
            ["thiefgec"] = true
        }

        if guildChannels[channel] then
            outputToConsole("GUI.ChatGuildConsole")
        end
    end
end
