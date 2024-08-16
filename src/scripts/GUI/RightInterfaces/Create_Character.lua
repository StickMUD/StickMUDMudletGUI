character_sections =
  {
    "BoxBrave",
    "BoxPkable",
    "BoxPoisoned",
    "BoxConfused",
    "BoxHallucinating",
    "BoxDrunk",
    "BoxRest",
    "BoxInvis",
    "BoxHunger",
    "BoxThirst",
    "BoxSummonable",
    "BoxFrog",
  }
character_icons =
  {
    "😱",
    "😈",
    "☠️️",
    "⁉",
    "🍄",
    "🍺",
    "💤️",
    "👻️",
    "🍞",
    "🥛",
    "✨",
    "🐸",
  }
character_tooltips =
  {
    "Brave",
    "PK Flag",
    "Poisoned",
    "Confused",
    "Hallucinating",
    "Drunk",
    "Resting",
    "Invisible",
    "Hungry",
    "Thirsty",
    "Summonable",
    "Frogged",
  }
character_stretch = {1, 1, 1, 1, 1.1, 1, 1, 1, 1, 1, 1.1, 1}

-- The icons will be contained here
GUI.LabelCharacter =
  Geyser.Label:new(
    {name = "GUI.LabelCharacter", x = 0, y = "94%", width = "100%", height = "6%"}, GUI.Right
  )
  GUI.LabelCharacter:setStyleSheet([[
  	QLabel{
			background-color: rgba(0,0,0,255);
		}
		]])

-- The icons will be contained here
GUI.HBoxCharacter =
  Geyser.HBox:new(
    {name = "GUI.HBoxCharacter", x = 0, y = "94%", width = "100%", height = "6%"}, GUI.LabelCharacter
  )
	
-- Add the icons and events
for index = 1, #character_sections do
  local section_value = character_sections[index]
  local icon_value = character_icons[index]
  local tooltip_value = character_tooltips[index]
  local stretch_value = character_stretch[index]
  GUI[section_value] =
    GUI[section_value] or
    Geyser.Label:new(
      {
        name = "GUI." .. section_value,
        h_stretch_factor = stretch_value,
        message = "<center><font size=\"6\">" .. icon_value .. "</font></center>",
      },
      GUI.HBoxCharacter
    )
  GUI[section_value]:setStyleSheet(GUI.BoxRightCSS:getCSS())
  GUI[section_value]:setOnEnter(
    "enable_tooltip",
    GUI[section_value],
    "<center><b><font size=\"4\">" .. icon_value .. "</font></b><br>" .. tooltip_value
  )
  GUI[section_value]:setOnLeave(
    "disable_tooltip",
    GUI[section_value],
    "<center><b><font size=\"6\">" .. icon_value .. "</font></b>"
  )
end