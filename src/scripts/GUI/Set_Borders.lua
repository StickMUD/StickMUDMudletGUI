-- Function to update borders based on current window size
function updateBorders()
    local w, h = getMainWindowSize()
    setBorderLeft(0)
    setBorderTop(h/20)
    setBorderBottom(h/10)
    setBorderRight(w*0.42)
end

-- Set initial borders
updateBorders()

-- Register handler for window resize events
registerAnonymousEventHandler("sysWindowResizeEvent", "updateBorders")