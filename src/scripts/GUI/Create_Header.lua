local header_sections = {
    "BoxStickMUD", "BoxAmulet", "BoxArmour", "BoxBelt", "BoxBoots",
    "BoxBracers", "BoxCloak", "BoxGloves", "BoxHelmet", "BoxLeggings",
    "BoxMask", "BoxNecklace", "BoxRing", "BoxRing2", "BoxShield", "BoxShoulders"
}
local header_icons = {
    "STICKMUD", "001-amulet.png", "006-armour.png", "005-belt.png",
    "007-boots.png", "002-gauntlet.png", "008-cloak.png", "004-gauntlet-2.png",
    "009-helmet.png", "053-armor.png", "054-mask.png", "010-necklace.png",
    "012-magic-ring-1.png", "011-magic-ring.png", "013-knight.png",
    "014-body-armor.png"
}
local header_tooltips = {
    "Est. 1991", "Amulet", "Armour", "Belt", "Boots", "Bracers", "Cloak",
    "Gloves", "Helmet", "Leggings", "Mask", "Necklace", "Ring", "Ring 2",
    "Shield", "Shoulders"
}
local header_stretch = {1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

GUI.BoxHeaderCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
  qproperty-wordWrap: true;
]])

-- The icons will be contained here
GUI.HBoxEquipment = Geyser.HBox:new({
    name = "GUI.HBoxCharacter",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%"
}, GUI.Top)

-- Helper function to create a section label
local function createSectionLabel(name, icon, tooltip, stretch, isText)
    local message = isText and
        ("<center><b><font size=\"3\">" .. icon .. "</font></b>") or
        ("<center><b><font size=\"6\"><img src=\"" .. getMudletHomeDir() .. "/StickMUD/" .. icon .. "\"></font></b>")
    
    local sectionLabel = Geyser.Label:new({
        name = name,
        message = message,
        h_stretch_factor = stretch
    }, GUI.HBoxEquipment)
    
    sectionLabel:setStyleSheet(GUI.BoxHeaderCSS:getCSS())
    
    -- Tooltip configurations
    local enterMessage = isText and
        ("<center><b><font size=\"2\">" .. icon .. "</font></b><br>" .. tooltip) or
        ("<center><b><font size=\"3\"><img src=\"" .. getMudletHomeDir() .. "/StickMUD/" .. icon .. "\"></font></b><br>" .. tooltip)
    
    local leaveMessage = message
    
    sectionLabel:setOnEnter("enable_tooltip", sectionLabel, enterMessage)
    sectionLabel:setOnLeave("disable_tooltip", sectionLabel, leaveMessage)
    
    return sectionLabel
end

-- Add sections to GUI
for i, section in ipairs(header_sections) do
    local icon = header_icons[i]
    local tooltip = header_tooltips[i]
    local stretch = header_stretch[i]
    
    GUI[section] = GUI[section] or createSectionLabel("GUI." .. section, icon, tooltip, stretch, section == "BoxStickMUD")
end
