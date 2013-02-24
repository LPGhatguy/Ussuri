--[[
Two-State Check Box
Checks Boxes
Inherits ui.base
]]

local lib
local checkbox

checkbox = {
	checked = false,
	width = 10,
	height = 10,
	background_color = {200, 200, 200},
	check_color = {0, 80, 200},
	border_color = {50, 50, 50},

	draw = function(self)
		local x, y, width, height = self.x, self.y, self.width, self.height

		love.graphics.setColor(self.background_color)
		love.graphics.rectangle("fill", x, y, width, height)

		love.graphics.setColor(self.border_color)
		love.graphics.rectangle("line", x, y, width, height)

		if (self.checked) then
			love.graphics.setColor(self.check_color)
			love.graphics.rectangle("fill", x + 1, y + 1, width - 2, height - 2)
		end
	end,

	mousedown = function(self, event)
		self.checked = not self.checked
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.ui.base, true)

		return self
	end
}

checkbox.event = {
	draw = checkbox.draw,
	mousedown = checkbox.mousedown
}

return checkbox