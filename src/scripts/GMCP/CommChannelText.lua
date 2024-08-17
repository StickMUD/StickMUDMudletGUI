function CommChannelText()
    local channel = gmcp.Comm.Channel.Text.channel
    local text = gmcp.Comm.Channel.Text.text
    local timeStamp = os.date("%I:%M ")

    -- Function to handle the output to a specific console
    local function outputToConsole(consoleName)
        setFont(consoleName, getFont())
        setMiniConsoleFontSize(consoleName, getFontSize() - 2)
        cecho(consoleName, "<cyan:black>" .. timeStamp .. text .. "\n\n")
    end

    -- Output to the general chat console
    outputToConsole("GUI.ChatAllConsole")

    -- Define the channel to console mapping
    local channelConsoleMap = {
        ["Tell"] = "GUI.ChatTellsConsole",
        ["Local"] = "GUI.ChatLocalConsole"
    }

    -- Check for specific channels
    if string.find(channel, "^&") then
        outputToConsole("GUI.ChatClanConsole")
    elseif channelConsoleMap[channel] then
        outputToConsole(channelConsoleMap[channel])
    else
        -- Guild channels
        local guildChannels = {
            bard = true,
            bardleaders = true,
            fighter = true,
            fighterofc = true,
            healer = true,
            healerchief = true,
            mage = true,
            magecouncil = true,
            necro = true,
            necrocouncil = true,
            ninja = true,
            ninjakanbu = true,
            priest = true,
            priestofc = true,
            thief = true,
            thiefarc = true,
            thiefdmn = true,
            thiefgec = true
        }

        if guildChannels[channel] then
            outputToConsole("GUI.ChatGuildConsole")
        end
    end
end
