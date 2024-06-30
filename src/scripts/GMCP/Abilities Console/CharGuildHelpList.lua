function CharGuildHelpList()
  local guild_help_list = gmcp.Char.Guild.Help.List
  local tkeys = {}
  local t2 = {}
  local count = 0
  local buffer = ""
  clearWindow("GUI.AbilitiesConsole")
  if getOS() == "mac" then
    GUI.AbilitiesConsole:setFontSize(10)
  else
    GUI.AbilitiesConsole:setFontSize(8)
  end
  GUI.AbilitiesConsole:resetAutoWrap()
  -- populate the table that holds the keys
  for k in pairs(guild_help_list) do
    table.insert(tkeys, k)
  end
  -- sort the keys
  table.sort(tkeys)
  -- use the keys to retrieve the values in the sorted order
  for _, k in ipairs(tkeys) do
    -- function
    table.sort(
      guild_help_list[k],
      function(v1, v2)
        return v1 < v2
      end
    )
    if count > 0 then
      cecho("GUI.AbilitiesConsole", "\n<yellow>" .. firstToUpper(k) .. ":\n")
    else
      cecho("GUI.AbilitiesConsole", "<yellow>" .. firstToUpper(k) .. ":\n")
    end
    for k2, v2 in pairs(guild_help_list[k]) do
      count = count + 1
      cecho("GUI.AbilitiesConsole", "  ")
      cecho("GUI.AbilitiesConsole", "<cyan>" .. v2 .. " <reset>")
      cechoLink(
        "GUI.AbilitiesConsole",
        "<magenta>?<reset>",
        [[send("ghelp ]] .. v2 .. [[", false)]],
        "Help",
        true
      )
      echo("GUI.AbilitiesConsole", string.rep(" ", 15 - string.len(v2)))
      if count % 2 == 0 then
        echo("GUI.AbilitiesConsole", "\n")
      end
    end
    if count % 2 ~= 0 then
      cecho("GUI.AbilitiesConsole", "\n")
    end
  end
end