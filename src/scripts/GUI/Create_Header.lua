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

-- Shared card style for icon containers (edge cards - more prominent)
GUI.IconCardCSS = [[
  background-color: #222230;
  border: 1px solid #32323f;
  border-radius: 6px;
]]

GUI.BoxHeaderCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  qproperty-wordWrap: true;
]])

GUI.BoxHeaderHoverCSS = CSSMan.new([[
  background-color: rgba(255,255,255,15);
  qproperty-wordWrap: true;
]])

-- Card container for header
GUI.HeaderCard = Geyser.Label:new({
    name = "GUI.HeaderCard",
    x = "2px", y = "2px",
    width = "-4px", height = "-4px"
}, GUI.Top)
GUI.HeaderCard:setStyleSheet(GUI.IconCardCSS)

-- The icons will be contained here
GUI.HBoxEquipment = Geyser.HBox:new({
    name = "GUI.HBoxCharacter",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%"
}, GUI.HeaderCard)

-- Hover effect handlers for header icons
function HeaderIconEnter(label, enterMessage)
    label:setStyleSheet(GUI.BoxHeaderHoverCSS:getCSS())
    enable_tooltip(label, enterMessage)
end

function HeaderIconLeave(label, leaveMessage)
    -- Restore the stored background or default to transparent
    local storedCSS = GUI.IconBackgrounds and GUI.IconBackgrounds[label.name] or GUI.BoxHeaderCSS:getCSS()
    label:setStyleSheet(storedCSS)
    disable_tooltip(label, leaveMessage)
end

-- Helper function to create a section label
local function createSectionLabel(name, icon, tooltip, stretch, isText)
    local message = isText and
        ("<center><b><font size=\"3\">" .. icon .. "</font></b>") or
        ("<center><img src=\"" .. getMudletHomeDir() .. "/StickMUD/" .. icon .. "\">")
    
    local sectionLabel = Geyser.Label:new({
        name = name,
        message = message,
        h_stretch_factor = stretch
    }, GUI.HBoxEquipment)
    
    sectionLabel:setStyleSheet(GUI.BoxHeaderCSS:getCSS())
    -- Store initial background for hover restoration
    GUI.IconBackgrounds[name] = GUI.BoxHeaderCSS:getCSS()
    
    -- Tooltip configurations
    local enterMessage = isText and
        ("<center><b><font size=\"2\">" .. icon .. "</font></b><br>" .. tooltip) or
        ("<center><img src=\"" .. getMudletHomeDir() .. "/StickMUD/" .. icon .. "\" width=\"32\" height=\"32\"><br>" .. tooltip)
    
    local leaveMessage = message
    
    -- Use custom hover handlers with visual effect
    sectionLabel:setOnEnter("HeaderIconEnter", sectionLabel, enterMessage)
    sectionLabel:setOnLeave("HeaderIconLeave", sectionLabel, leaveMessage)

    if icon == "STICKMUD" then
        sectionLabel:setClickCallback(function()
            openWebPage("https://www.patreon.com/bePatron?u=43734767&redirect_uri=https%3A%2F%2Fwww.stickmud.com%2F")
        end)
    end
    
    return sectionLabel
end

-- Add sections to GUI
for i, section in ipairs(header_sections) do
    local icon = header_icons[i]
    local tooltip = header_tooltips[i]
    local stretch = header_stretch[i]
    
    GUI[section] = GUI[section] or createSectionLabel("GUI." .. section, icon, tooltip, stretch, section == "BoxStickMUD")
end
