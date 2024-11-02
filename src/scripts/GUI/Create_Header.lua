header_sections =
  {
    "BoxStickMUD",
    "BoxAmulet",
    "BoxArmour",
    "BoxBelt",
    "BoxBoots",
    "BoxBracers",
    "BoxCloak",
    "BoxGloves",
    "BoxHelmet",
    "BoxLeggings",
    "BoxMask",
		"BoxNecklace",
    "BoxRing",
    "BoxRing2",
    "BoxShield",
    "BoxShoulders",
  }
header_icons =
  {
    "STICKMUD",
    "001-amulet.png",
    "006-armour.png",
    "005-belt.png",
    "007-boots.png",
    "002-gauntlet.png",
    "008-cloak.png",
    "004-gauntlet-2.png",
    "009-helmet.png",
    "053-armor.png",
    "054-mask.png",
    "010-necklace.png",
    "012-magic-ring-1.png",
    "011-magic-ring.png",
    "013-knight.png",
    "014-body-armor.png",
  }
header_tooltips =
  {
    "Est. 1991",
    "Amulet",
    "Armour",
    "Belt",
    "Boots",
    "Bracers",
    "Cloak",
    "Gloves",
    "Helmet",
    "Leggings",
    "Mask",
    "Necklace",
    "Ring",
    "Ring 2",
    "Shield",
    "Shoulders",
  }
header_stretch = {1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

GUI.BoxHeaderCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
	qproperty-wordWrap: true;
]])

-- The icons will be contained here
GUI.HBoxEquipment =
  Geyser.HBox:new(
    {name = "GUI.HBoxCharacter", x = 0, y = 0, width = "100%", height = "100%"}, GUI.Top
  )
	
-- Add the icons and events
for index = 1, #header_sections do
  local section_value = header_sections[index]
  local icon_value = header_icons[index]
  local tooltip_value = header_tooltips[index]
  local stretch_value = header_stretch[index]
	
  if section_value ~= "BoxStickMUD" then
    GUI[section_value] =
      GUI[section_value] or
      Geyser.Label:new(
        {
          name = "GUI." .. section_value,
          message = "<center><b><font size=\"6\">" .. icon_value .. "</font></b>",
          h_stretch_factor = stretch_value,
        },
        GUI.HBoxEquipment
      )
    GUI[section_value]:setStyleSheet(GUI.BoxHeaderCSS:getCSS())
    GUI[section_value]:setOnEnter(
      "enable_tooltip",
      GUI[section_value],
      "<center><b><font size=\"3\">" .. icon_value .. "</font></b><br>" .. tooltip_value
    )
    GUI[section_value]:setOnLeave(
      "disable_tooltip",
      GUI[section_value],
      "<center><b><font size=\"6\">" .. icon_value .. "</font></b>"
    )
  else
    GUI[section_value] =
      GUI[section_value] or
      Geyser.Label:new(
        {
          name = "GUI." .. section_value,
          h_stretch_factor = stretch_value,
        },
        GUI.HBoxEquipment
      )
    GUI[section_value]:setStyleSheet([[
      background-color: rgba(0,0,0,100);
      background-image: url("]] .. getMudletHomeDir() .. [[/StickMUD/]] .. icon_value .. [[");
      background-repeat: no-repeat; background-position: center middle;
    ]])
    GUI[section_value]:setOnEnter(
      "enable_tooltip",
      GUI[section_value],
      "<center><b><font size=\"2\">" .. icon_value .. "</font></b><br>" .. tooltip_value
    )
    GUI[section_value]:setOnLeave(
      "disable_tooltip",
      GUI[section_value],
      "<center><b><font size=\"3\">" .. icon_value .. "</font></b>"
    )
  end
end