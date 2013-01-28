--[[
State Machine
A state machine with possible (but not critical) integration into Ussuri's event framework
]]

local lib
local state

state = {
	event = {},
	pre = {},
	post = {},
	handlers = {},
	state = "",

	set_state = function(self, value)
		self.event["state_changing"](self, {})

		self.state = value

		self.event["state_changed"](self, {})
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		return self
	end
}

setmetatable(state.event, {
	__index = function(self, key)
		local event = function(machine, ...)
			local handlers = machine.handlers[machine.state]

			local pre = machine.pre[key]
			local post = machine.post[key]

			if (pre) then
				pre(machine, ...)
			end

			if (handlers) then
				local method = handlers[key]

				if (method) then
					method(machine, ...)
				end
			end

			if (post) then
				post(machine, ...)
			end
		end

		if (key) then
			self[key] = event
		end
		return event
	end
})

return state