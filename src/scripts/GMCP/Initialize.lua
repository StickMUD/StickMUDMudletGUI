abilitiesTimers = {}

tempTimer(
  1.0,
  function()
    GUI.MapperConsole =
      GUI.MapperConsole or
      Geyser.Mapper:new(
        {name = "GUI.MapperConsole", x = 0, y = 0, height = "100%", width = "100%"}, GUI.ContentBox
      )
    on_content_box_press("BoxMap")
  end
)

sendGMCP("Char.Vitals")
sendGMCP("Char.Status")
sendGMCP("Game.Players.List")