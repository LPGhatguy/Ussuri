--[[
Button
A clickable button
Inherits gui.base
]]

local lib
local button

button = {
	background_color = {200, 200, 200},

	draw = function(self)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end,

	mousedown = function(self)
		self.event_mousedown()
	end,

	new = function(self)
		local instance = self:_new()

		instance.event_mousedown = lib.misc.event:new()

		return instance
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.gui.base)
	end
}

return button