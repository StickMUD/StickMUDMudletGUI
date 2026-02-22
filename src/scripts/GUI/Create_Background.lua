-- Get initial layout values
local function getInitialLayout()
    local layout = getLayoutValues()
    local totalRight = layout.rightPanelWidth + layout.middleWidth
    local middlePercent = math.floor(layout.middleWidth * 100)
    local rightPercent = math.floor(layout.rightPanelWidth * 100)
    local mainPercent = 100 - middlePercent - rightPercent
    local headerFooterPercent = mainPercent + middlePercent  -- Header/footer cover main + middle
    return {
        totalRight = totalRight,
        middlePercent = middlePercent,
        rightPercent = rightPercent,
        headerFooterPercent = headerFooterPercent
    }
end

local initLayout = getInitialLayout()

-- Abilities panel - positioned between main window and right content panel
GUI.Middle = Geyser.Label:new({
  name = "GUI.Middle",
  x = "-" .. (initLayout.middlePercent + initLayout.rightPercent) .. "%", y = "7%",
  width = initLayout.middlePercent .. "%",
  height = "83%",
})
setBackgroundColor("GUI.Middle", 0, 0, 0)
GUI.Middle:raise()

GUI.Right = Geyser.Label:new({
  name = "GUI.Right",
  x = "-" .. initLayout.rightPercent .. "%", y = 0,
  width = initLayout.rightPercent .. "%",
  height = "100%",
})
setBackgroundColor("GUI.Right", 0, 0, 0)

GUI.Top = Geyser.Label:new({
  name = "GUI.Top",
  x = 0, y = 0,
  width = initLayout.headerFooterPercent .. "%",
  height = "7%",
})
setBackgroundColor("GUI.Top", 0, 0, 0)

GUI.Bottom = Geyser.Label:new({
  name = "GUI.Bottom",
  x = 0, y = "90%",
  width = initLayout.headerFooterPercent .. "%",
  height = "10%",
})
setBackgroundColor("GUI.Bottom", 0, 0, 0)

-- Function to update layout panels when preset changes
function updateLayoutPanels()
    local layout = getLayoutValues()
    local middlePercent = math.floor(layout.middleWidth * 100)
    local rightPercent = math.floor(layout.rightPanelWidth * 100)
    local mainPercent = 100 - middlePercent - rightPercent
    local headerFooterPercent = mainPercent + middlePercent
    
    -- Update Middle panel
    GUI.Middle:move("-" .. (middlePercent + rightPercent) .. "%", "7%")
    GUI.Middle:resize(middlePercent .. "%", "83%")
    
    -- Update Right panel
    GUI.Right:move("-" .. rightPercent .. "%", 0)
    GUI.Right:resize(rightPercent .. "%", "100%")
    
    -- Update Top panel
    GUI.Top:resize(headerFooterPercent .. "%", "7%")
    
    -- Update Bottom panel
    GUI.Bottom:resize(headerFooterPercent .. "%", "10%")
end