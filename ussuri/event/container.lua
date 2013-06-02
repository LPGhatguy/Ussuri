--[[
Container
Contains objects and registers them to the event hierarchy
]]

local lib
local container

container = {
	children = {},

	get = function(self, id)
		return children[id]
	end,

	add = function(self, item, id)
		id = id or (#self.children + 1)

		self.children[id] = item

		self:event_hook_object(nil, item)
	end,

	remove = function(self, id)
		local item = self.children[id]

		if (item) then
			self:event_unhook_by_object(item)
			self.children[id] = nil
		end
	end,

	_new = function(base, new)
		for key, flag in pairs(new.auto_hook) do
			new:event_create(key)
		end

		return new
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		self:inherit(engine:lib_get(":event.handler"))
	end
}

return container