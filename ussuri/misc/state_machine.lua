--[[
State Machine
A state machine with possible (but not critical) integration into Ussuri's event framework
]]

local state = {}
local lib

state.event = {}
state.state = ""
state.pre = {}
state.post = {}
state.handlers = {}

state.set_state = function(self, value)
	self.event["state_changing"](self, {})

	self.state = value

	self.event["state_changed"](self, {})
end

setmetatable(state.event, {
	__index = function(self, key)
		local event = function(machine, ...)
			local handlers = machine.handlers[machine.state]

			if (handlers) then
				local method = handlers[key]
				local pre = machine.pre[key]
				local post = machine.post[key]

				if (pre) then
					pre(machine, ...)
				end

				if (method) then
					method(machine, ...)
				end

				if (post) then
					post(machine, ...)
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