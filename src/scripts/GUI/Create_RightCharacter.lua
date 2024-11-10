-- Data tables for character status sections, icons, tooltips, and stretch factors
local character_data = {
  { section = "BoxBrave", icon = "026-running.png", tooltip = "Brave", stretch = 1 },
  { section = "BoxPkable", icon = "027-skull.png", tooltip = "PK Flag", stretch = 1 },
  { section = "BoxPoisoned", icon = "028-poisonous.png", tooltip = "Poisoned", stretch = 1 },
  { section = "BoxConfused", icon = "029-dazed.png", tooltip = "Confused", stretch = 1 },
  { section = "BoxHallucinating", icon = "030-hallucination.png", tooltip = "Hallucinating", stretch = 1.1 },
  { section = "BoxDrunk", icon = "031-drunk.png", tooltip = "Drunk", stretch = 1 },
  { section = "BoxRest", icon = "032-rest.png", tooltip = "Resting", stretch = 1 },
  { section = "BoxInvis", icon = "033-invisible-man.png", tooltip = "Invisible", stretch = 1 },
  { section = "BoxHunger", icon = "034-hungry.png", tooltip = "Hungry", stretch = 1 },
  { section = "BoxThirst", icon = "035-water.png", tooltip = "Thirsty", stretch = 1 },
  { section = "BoxSummonable", icon = "036-portal.png", tooltip = "Summonable", stretch = 1.1 },
  { section = "BoxFrog", icon = "037-amazon-river.png", tooltip = "Frogged", stretch = 1 }
}

-- Main container for character status icons
GUI.LabelCharacter = Geyser.Label:new({
  name = "GUI.LabelCharacter",
  x = 0, y = "93%", width = "100%", height = "7%"
}, GUI.Right)
GUI.LabelCharacter:setStyleSheet([[
  QLabel { background-color: rgba(0,0,0,255); }
]])

GUI.HBoxCharacter = Geyser.HBox:new({
  name = "GUI.HBoxCharacter",
  x = 0, y = "93%", width = "100%", height = "7%"
}, GUI.Right)

-- Function to initialize character status boxes
local function createCharacterBox(data)
  local iconPath = getMudletHomeDir() .. "/StickMUD/" .. data.icon
  GUI[data.section] = Geyser.Label:new({
      name = "GUI." .. data.section,
      h_stretch_factor = data.stretch,
      message = string.format("<center><img src=\"%s\">", iconPath)
  }, GUI.HBoxCharacter)

  GUI[data.section]:setStyleSheet(GUI.BoxRightCSS:getCSS())
  GUI[data.section]:setOnEnter("enable_tooltip", GUI[data.section], string.format(
      "<center><img src=\"%s\"><br>%s", iconPath, data.tooltip))
  GUI[data.section]:setOnLeave("disable_tooltip", GUI[data.section], string.format(
      "<center><img src=\"%s\">", iconPath))
end

-- Initialize all character boxes
for _, data in ipairs(character_data) do
  createCharacterBox(data)
end