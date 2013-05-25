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

	_new = function(self, x, y, w, h)
		local instance = self:copy()

		instance.x = x or 0
		instance.y = y or 0
		instance.width = w or 0
		instance.height = h or 0

		return instance
	end,

	draw = function(self)
		--stub abstract method
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return base