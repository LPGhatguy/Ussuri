--[[
UI Rectangle
Draws a rectangle
]]

local lib
local rectangle

rectangle = {
	draw = function(self)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		self:inherit(engine:lib_get("ui.base"))
	end
}

return rectangle