--[[
Base UI Item
The father of all UI items
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
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return base