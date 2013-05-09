--[[
UI Base
The root of UI items
Part of the new UI rewrite to follow the new event scheme
]]

local lib
local base

base = {
	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return base