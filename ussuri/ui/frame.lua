--[[
UI Frame
A frame for holding other UI elements
Inherits ui.base, ui.container, ui.rectangle
]]

local lib
local frame

frame = {
	draw = function(self)
		self._rectangle.draw(self)
		self._container.draw(self)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.ui.base)
		self:inherit(lib.ui.container, "container")
		self:inherit(lib.ui.rectangle, "rectangle")

		self.event.draw = self.draw
	end
}

return frame