--[[
Input Manager
Manages control bindings
Inherits oop.object
]]

local lib
local input

input = {
	actions = {},
	buttons = {},

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return input