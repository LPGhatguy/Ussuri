--[[
UI Base
The root of UI items
Part of the new UI rewrite to follow the new event scheme
]]

local lib
local base

base = {
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	visible = true,

	draw = function(self)
		print("stub draw")
		--stub abstract method
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return base