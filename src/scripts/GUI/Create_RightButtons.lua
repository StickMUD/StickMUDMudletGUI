-- The buttons will be contained here
--GUI.VBoxButtons =
  --Geyser.VBox:new({name = "GUI.VBoxButtons", x = 0, y = 0, width = "20%", height = "95%"}, GUI.Right)

--GUI.AbilityLabelCSS = CSSMan.new([[
  --background-color: rgba(0,0,0,0);
--]])
	
-- Add the gauges
--for index = 1, 19 do
  --if index == 1 then
    --GUI["AbilityLabel"] =
      --Geyser.Label:new(
        --{
          --name = "GUI.AbilityLabel",
          --message = "",
        --},
        --GUI.VBoxButtons
      --)
    --GUI["AbilityLabel"]:setStyleSheet(GUI.AbilityLabelCSS:getCSS())
  --else
    --gauge_name = "AbilityGauge" .. index;
  
  	--GUI[gauge_name] = Geyser.Gauge:new({
      --name = "GUI." .. gauge_name,
      --width = "100%",
      --height = "5%",
    --},GUI.VBoxButtons)
  
    --GUI[gauge_name].back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
    --GUI.GaugeFrontCSS:set("background-color","white")
    --GUI[gauge_name].front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
    --GUI[gauge_name]:setValue(math.random(100),100)
    --GUI[gauge_name]:hide()
  --end
--end
