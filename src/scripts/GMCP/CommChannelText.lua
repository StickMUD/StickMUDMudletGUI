function CommChannelText()
	local channel = gmcp.Comm.Channel.Text.channel
	local talker = gmcp.Comm.Channel.Text.talker
	local text = gmcp.Comm.Channel.Text.text
	
	cecho("GUI.ChatAllConsole", "<cyan:black>"..os.date("%I:%M ")..text.."\n\n")
	
	local start, finish = string.find(channel, "&")

	if start then --it does start with an ampersand
		cecho("GUI.ChatClanConsole", "<cyan:black>"..os.date("%I:%M ")..text.."\n\n")
	elseif channel == "Tell" then
  	cecho("GUI.ChatTellsConsole", "<cyan:black>"..os.date("%I:%M ")..text.."\n\n")
	elseif channel == "Local" then
  	cecho("GUI.ChatLocalConsole", "<cyan:black>"..os.date("%I:%M ")..text.."\n\n")
	else  	
  	local guild_channels = {"bard", "bardleaders", "fighter", "fighterofc", "healer", "healerchief", "mage", "magecouncil", "necro", "necrocouncil", "ninja", "ninjakanbu", "priest", "priestofc", "thief", "thiefarc", "thiefdmn", "thiefgec"}
  	
  	for i=1,18 do
  		if channel == guild_channels[i] then
  			cecho("GUI.ChatGuildConsole", "<cyan:black>"..os.date("%I:%M ")..text.."\n\n")
  		end
  	end
	end
end