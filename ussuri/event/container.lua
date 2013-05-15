--[[
Container
Contains objects and registers them to the event hierarchy
]]

local lib
local container

container = {
	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(engine:lib_get(":event.handler"))
	end
}

return container