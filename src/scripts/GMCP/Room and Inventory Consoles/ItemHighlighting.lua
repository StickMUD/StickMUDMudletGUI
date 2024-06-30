--------------------------------------------------------------
--                     Item Highlighting                    --
--This section allows you to prefix each item with a colour.--
--You can match the strings or search for a pattern and     --
--then return a colour tag or prefix you want for that item.--
--                                                          --
--see: wiki.mudlet.org/w/Manual:Lua_Functions#string.find   --
--for examples of using find() and findPattern().           --
--------------------------------------------------------------
function getItemHighlight(value)

	-- Worn!
	if value.attrib == "w" then return "<spring_green>" end

	-- Wearable!  Get it!
	if value.attrib == "W" then return "<yellow>" end
		
	-- Takeable!
	if value.attrib == "t" then return "<green>" end

	-- Wielded!
	if value.attrib == "l" then return "<orange>" end

	-- Container!
	if value.attrib == "c" then return "<magenta>" end

	-- Monster!
	if value.attrib == "m" then return "<cyan>" end

	-- Corpse!
	if value.attrib == "d" then return "<gray>" end
	
	if value.name:find("coins") ~= nil then return "<gold>" end
end