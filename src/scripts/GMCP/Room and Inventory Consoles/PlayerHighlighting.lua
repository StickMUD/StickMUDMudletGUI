--------------------------------------------------------------
--                     Player Highlighting                    --
--This section allows you to prefix each item with a colour.--
--You can match the strings or search for a pattern and     --
--then return a colour tag or prefix you want for that item.--
--                                                          --
--see: wiki.mudlet.org/w/Manual:Lua_Functions#string.find   --
--for examples of using find() and findPattern().           --
--------------------------------------------------------------
function getPlayerHighlight(value)

	-- Here we'll do something with the Friends and Enemies lists in time...
	if value.name == "filth" then return "<blue>" end

	if value.fullname:find("dmin") ~= nil then return "<gold>" end
end