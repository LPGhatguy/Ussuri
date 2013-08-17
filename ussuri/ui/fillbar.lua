--[[
Fill Bar
Acts as a progress bar or such.
]]

local fillbar
local lib
local rectangle

fillbar = {
	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		rectangle = self:inherit(engine:lib_get(":ui.rectangle"))
	end
}

return fillbar