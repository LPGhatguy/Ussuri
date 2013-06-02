--[[
UI Frame
Contains objects inside a rectangle
]]

local lib
local ui_container
local rectangle
local frame

frame = {
	draw = function(self)
		rectangle.draw(self)
		ui_container.draw(self)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		ui_container = self:inherit(engine:lib_get(":ui.ui_container"))
		rectangle = self:inherit(engine:lib_get(":ui.rectangle"))
	end,
}

frame.event = {
	draw = frame.draw
}

return frame