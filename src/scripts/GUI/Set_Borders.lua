-- Function to recursively reposition a Geyser element and all its children
local function repositionRecursive(element)
    if not element then return end
    
    -- Reposition this element
    if element.reposition then
        element:reposition()
    end
    
    -- Reposition all children
    if element.windowList then
        for _, child in pairs(element.windowList) do
            repositionRecursive(child)
        end
    end
end

-- Function to update borders based on current window size
function updateBorders()
    local w, h = getMainWindowSize()
    setBorderLeft(w*0.10)
    setBorderTop(h/20)
    setBorderBottom(h/10)
    setBorderRight(w*0.42)
    
    -- Reposition main GUI containers and all children to adapt to new window size
    if GUI then
        repositionRecursive(GUI.Left)
        repositionRecursive(GUI.Right)
        repositionRecursive(GUI.Top)
        repositionRecursive(GUI.Bottom)
    end
end

-- Set initial borders
updateBorders()

-- Register handler for window resize events
registerAnonymousEventHandler("sysWindowResizeEvent", "updateBorders")