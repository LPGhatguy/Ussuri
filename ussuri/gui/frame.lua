--[[
GUI Frame
A frame for holding other GUI elements
Inherits gui.container
]]

local lib
local frame

frame = {
	background_color = {0, 0, 0},
	border_color = {255, 255, 255},
	padding_x = 2,
	padding_y = 2,

	draw = function(self)
		love.graphics.setColor(self.background_color)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

		love.graphics.setColor(self.border_color)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

		self._container.draw(self)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.gui.container, "container")

		self.event.draw = self.draw

		return self
	end
}

return frame