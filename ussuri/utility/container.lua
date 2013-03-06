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

	trigger_child_event = function(self, child, event_name, event_pass)
		if (child[event_name]) then
			child[event_name](child, event_pass)
		elseif (child.trigger_event) then
			child:trigger_event(event_name, event_pass)
		end
	end,

	trigger_event = function(self, event_name, event_pass)
		local stack = event_pass.stack
		stack[#stack + 1] = self
		event_pass.up = self

		for key, child in next, self.children do
			self:trigger_child_event(child, event_name, event_pass)
		end

		stack[#stack] = nil
		event_pass.up = stack[#stack]
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

return container