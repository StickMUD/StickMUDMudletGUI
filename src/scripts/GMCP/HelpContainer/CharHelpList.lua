selected_help_topic = nil

function on_helplabel_press(category)
    selected_help_topic = category
    CharHelpList()
end

function CharHelpList()
    local help_list = gmcp.Char.Help.List
    local num_topics = 0
    local console_height = 0
    local current_y = 0
    local tkeys = {}
    local t2 = {}
    local count = 0

    clearWindow("GUI.HelpConsole")

    -- populate the table that holds the keys
    for k in pairs(help_list) do
        table.insert(tkeys, k)
        num_topics = num_topics + 1
    end

    console_height = 100 - num_topics * 5

    -- sort the keys
    table.sort(tkeys)

    -- use the keys to retrieve the values in the sorted order
    for _, k in ipairs(tkeys) do
        table.sort(help_list[k], function(v1, v2) return v1 < v2 end -- function
        )

        GUI["HelpLabel" .. k] = Geyser.Label:new({
            name = ("GUI.HelpLabel" .. k),
            x = 0,
            y = (current_y .. "%"),
            width = "100%",
            height = "5%"
        }, GUI.HelpContainer)

        current_y = current_y + 5

        -- Add a border to the label when it is hovered over
        GUI["HelpLabel" .. k]:setStyleSheet([[
  		QLabel{
			background-color: rgba(0,0,0,255);
			qproperty-wordWrap: true;
    		border: 4px double red;
    		border-radius: 4px;
		}
  		QLabel::hover{
			background-color: rgba(255,0,0,0%);
			qproperty-wordWrap: true;
    		border: 4px double blue;
    		border-radius: 4px;
  		}
		]])

        GUI["HelpLabel" .. k]:setStyleSheet([[
  		QLabel{
				background-color: rgba(0,0,0,255);
				qproperty-wordWrap: true;
    		border: 4px double blue;
			}
		]])

        GUI["HelpLabel" .. k]:echo(
            "<center><font size=\"3\" color=\"yellow\">" .. firstToUpper(k) ..
                "</font></center>")

        GUI["HelpLabel" .. k]:setClickCallback("on_helplabel_press", k)

        if selected_help_topic == nil then selected_help_topic = k end

        if selected_help_topic == k then
            GUI.HelpConsole = Geyser.MiniConsole:new({
                name = "GUI.HelpConsole",
                x = 0,
                y = (current_y .. "%"),
                height = (console_height .. "%"),
                width = GUI.HelpContainer:get_width()
            }, GUI.HelpContainer)
            setBackgroundColor("GUI.HelpConsole", 0, 0, 0, 0)
            setFont("GUI.HelpConsole", getFont())
            setMiniConsoleFontSize("GUI.HelpConsole",
                                   content_preferences["GUI.HelpConsole"]
                                       .fontSize)
            setFgColor("GUI.HelpConsole", 192, 192, 192)
            setBgColor("GUI.HelpConsole", 0, 0, 0)
            GUI.HelpConsole:enableAutoWrap()

            -- Create and style '+' and '-' labels
            createControlLabel("HelpConsole", "Plus", "-50px", "+")
            createControlLabel("HelpConsole", "Minus", "-25px", "-")
        
            -- Connect labels to font adjustment functions
            GUI["HelpConsole" .. "PlusLabel"]:setClickCallback(
                increaseFontSize, GUI["HelpConsole"])
            GUI["HelpConsole" .. "MinusLabel"]:setClickCallback(
                decreaseFontSize, GUI["HelpConsole"])

            current_y = current_y + console_height

            for k2, v2 in pairs(help_list[k]) do
                if count == 0 then echo("GUI.HelpConsole", "\n") end

                count = count + 1

                cecho("GUI.HelpConsole", "<cyan>" .. v2 .. " <reset>")
                cechoLink("GUI.HelpConsole", "<magenta>?<reset>",
                          [[send("help ]] .. v2 .. [[", false)]],
                          ("Help on " .. v2), true)

                if count % 3 == 0 then
                    echo("GUI.HelpConsole", "\n")
                else
                    echo("GUI.HelpConsole", string.rep(" ", 15 - string.len(v2)))
                end
            end

            if count % 3 ~= 0 then cecho("GUI.HelpConsole", "\n") end

            count = 0
        end
    end

    if selected_console ~= "HelpContainer" then
        on_menu_box_press("BoxPlayers")
    end
end
