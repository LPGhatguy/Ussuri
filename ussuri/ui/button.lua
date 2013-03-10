--[[
Button
A clickable button
Inherits ui.base, ui.rectangle
]]

local lib
local button

button = {
	background_color = {200, 200, 200},

	mousedown = function(self, event)
		self:event_mousedown(event)
	end,

	new = function(self)
		local instance = self:_new()

		instance.event_mousedown = lib.utility.event:new()
		instance.draw = self._rectangle.draw

		return instance
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.ui.rectangle, "rectangle")
	end
}

return button