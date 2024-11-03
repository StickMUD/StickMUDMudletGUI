local character_sections = {
  "BoxBrave", "BoxPkable", "BoxPoisoned", "BoxConfused", "BoxHallucinating",
  "BoxDrunk", "BoxRest", "BoxInvis", "BoxHunger", "BoxThirst",
  "BoxSummonable", "BoxFrog"
}
local character_icons = {
  "026-running.png", "027-skull.png", "028-poisonous.png", "029-dazed.png",
  "030-hallucination.png", "031-drunk.png", "032-rest.png", "033-invisible-man.png",
  "034-hungry.png", "035-water.png", "036-portal.png", "037-amazon-river.png"
}
local character_tooltips = {
  "Brave", "PK Flag", "Poisoned", "Confused", "Hallucinating",
  "Drunk", "Resting", "Invisible", "Hungry", "Thirsty",
  "Summonable", "Frogged"
}
local character_stretch = {1, 1, 1, 1, 1.1, 1, 1, 1, 1, 1, 1.1, 1}

-- Main container for character status icons
GUI.LabelCharacter = Geyser.Label:new({
  name = "GUI.LabelCharacter",
  x = 0, y = "94%", width = "100%", height = "6%"
}, GUI.Right)
GUI.LabelCharacter:setStyleSheet([[
  QLabel { background-color: rgba(0,0,0,255); }
]])

GUI.HBoxCharacter = Geyser.HBox:new({
  name = "GUI.HBoxCharacter",
  x = 0, y = "94%", width = "100%", height = "6%"
}, GUI.Right)

-- Helper function to create a character status box
local function createCharacterBox(index)
  local name = character_sections[index]
  local iconPath = getMudletHomeDir() .. "/StickMUD/" .. character_icons[index]
  local tooltip = character_tooltips[index]
  local stretch = character_stretch[index]

  GUI[name] = Geyser.Label:new({
      name = "GUI." .. name,
      h_stretch_factor = stretch,
      message = string.format("<center><font size=\"6\"><img src=\"%s\"></font></center>", iconPath)
  }, GUI.HBoxCharacter)

  GUI[name]:setStyleSheet(GUI.BoxRightCSS:getCSS())
  GUI[name]:setOnEnter("enable_tooltip", GUI[name], string.format(
      "<center><b><font size=\"4\"><img src=\"%s\"></font></b><br>%s", iconPath, tooltip))
  GUI[name]:setOnLeave("disable_tooltip", GUI[name], string.format(
      "<center><b><font size=\"6\"><img src=\"%s\"></font></b>", iconPath))
end

-- Create character status boxes
for i = 1, #character_sections do
  createCharacterBox(i)
end
