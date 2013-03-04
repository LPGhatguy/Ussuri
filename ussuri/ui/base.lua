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

	get_absolute_position = function(self, stack)
		local x, y = self.x, self.y

		for key, item in next, stack do
			if (item.x and item.y) then
				x = x + item.x
				y = y + item.y
			end
		end

		return x, y
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return base