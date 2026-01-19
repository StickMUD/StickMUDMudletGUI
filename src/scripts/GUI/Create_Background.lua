GUI.Left = Geyser.Label:new({
  name = "GUI.Left",
  x = 0, y = "7%",
  width = "10%",
  height = "83%",
})
setBackgroundColor("GUI.Left", 0, 0, 0)
GUI.Left:raise()

GUI.Right = Geyser.Label:new({
  name = "GUI.Right",
  x = "-42%", y = 0,
  width = "42%",
  height = "100%",
})
setBackgroundColor("GUI.Right", 0, 0, 0)

GUI.Top = Geyser.Label:new({
  name = "GUI.Top",
  x = 0, y = 0,
  width = "58%",
  height = "7%",
})
setBackgroundColor("GUI.Top", 0, 0, 0)

GUI.Bottom = Geyser.Label:new({
  name = "GUI.Bottom",
  x = 0, y = "90%",
  width = "58%",
  height = "10%",
})
setBackgroundColor("GUI.Bottom", 0, 0, 0)