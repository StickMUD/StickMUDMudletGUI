-- Credit: https://forums.mudlet.org/viewtopic.php?t=17624&start=10#p45054
if not GUI.ScrollStyle then
	GUI.ScrollStyle = GUI.ScrollStyle or 1
  --if getOS() == "windows" then
    local grey = "#31363b"
		local black = "#000000"
    local blue = "#2478c8"
    
    setAppStyleSheet([[
      QScrollBar:vertical {
         background: ]]..black..[[;
         width: 13px;
         margin: 13px 0 13px 0;
  			 border-radius: 7px;
      }
      QScrollBar:vertical:hover {
         background: ]]..grey..[[;
         width: 17px;
         margin: 13px 0 13px 0;
  			 border-radius: 7px;
      }
			
			QScrollBar:vertical:hover + QScrollBar::handle:vertical {
         background-color: ]]..blue..[[;
         min-height: 20px;
         border-width: 1px;
         border-style: solid;
         border-color: ]]..black..[[;
         border-radius: 7px;
      }
			
      QScrollBar::handle:vertical {
         background-color: ]]..grey..[[;
         min-height: 20px;
         border-width: 4px;
         border-style: solid;
         border-color: ]]..black..[[;
         border-radius: 7px;
      }
      QScrollBar::handle:vertical:hover {
         background-color: ]]..blue..[[;
         min-height: 20px;
         border-width: 1px;
         border-style: solid;
         border-color: ]]..black..[[;
         border-radius: 7px;
      }
      QScrollBar::add-line:vertical {
       background-color: ]]..black..[[;
       border-width: 1px;
       border-style: solid;
       border-color: ]]..black..[[;
       border-radius: 7px;
            height: 7px;
            subcontrol-position: bottom;
            subcontrol-origin: margin;
      }
      QScrollBar::sub-line:vertical {
       background-color: ]]..black..[[;
       border-width: 1px;
       border-style: solid;
       border-color: ]]..black..[[;
       border-radius: 7px;
            height: 7px;
            subcontrol-position: top;
            subcontrol-origin: margin;
      }
      QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {
         background: black;
         width: 3px;
         height: 3px;
      }
      QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
         background: none;
      }
    ]])
  --end
end