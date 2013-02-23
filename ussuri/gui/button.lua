--[[
Button
A clickable button
Inherits gui.base, gui.rectangle
]]

local lib
local button

button = {
	background_color = {200, 200, 200},

	mousedown = function(self)
		self.event_mousedown()
	end,

	new = function(self)
		local instance = self:_new()

		instance.event_mousedown = lib.misc.event:new()
		instance.draw = self._rectangle.draw

		return instance
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.gui.base)
		self:inherit(lib.gui.rectangle, "rectangle")
	end
}

return button