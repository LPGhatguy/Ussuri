--[[
State Machine
A state machine with possible (but not critical) integration into Ussuri's event framework
]]

local state = {}
local lib

state.event = {}
state.state = ""
state.handlers = {}

setmetatable(state.event, {
	__index = function(self, key)
		local event = function(machine, ...)
			local handlers = machine.handlers[machine.state]

			if (handlers) then
				local method = handlers[key]

				if (method) then
					method(machine, ...)
				end
			end
		end

		if (key) then
			self[key] = event
		end
		return event
	end
})

state.init = function(self, engine)
	lib = engine.lib

	lib.oop:objectify(self)

	return self
end

return state