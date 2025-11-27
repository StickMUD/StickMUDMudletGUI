abilitiesTimers = {}

-- Initialize GUI elements to default state before GMCP data is available
tempTimer(
  0.5,
  function()
    -- Initialize vitals and status displays to default empty state
    if InitializeVitals then InitializeVitals() end
    if InitializeStatus then InitializeStatus() end
    if InitializeRoomInfo then InitializeRoomInfo() end
    if InitializeInventoryConsoles then InitializeInventoryConsoles() end
  end
)

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

-- Request GMCP data from server (will update GUI when responses arrive)
sendGMCP("Char.Vitals")
sendGMCP("Char.Status")
sendGMCP("Game.Players.List")