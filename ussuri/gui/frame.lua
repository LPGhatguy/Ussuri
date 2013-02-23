--[[
GUI Frame
A frame for holding other GUI elements
Inherits gui.base, gui.container, gui.rectangle
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
		self:inherit(lib.gui.base)
		self:inherit(lib.gui.container, "container")
		self:inherit(lib.gui.rectangle, "rectangle")

		self.event.draw = self.draw

		return self
	end
}

return frame