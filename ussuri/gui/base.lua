--[[
Base GUI Item
The father of all GUI items (the mother is defined by the item itself)
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

		return self
	end
}

return base