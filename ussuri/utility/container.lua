--[[
Container
Contains items and handles event passing to them
]]

local lib
local container

container = {
	children = {},

	add = function(self, object)
		table.insert(self.children, object)
	end,

	register = function(self, key, object)
		self.children[key] = object
	end,

	remove = function(self, key)
		self.children[key] = nil
	end,

	

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return container