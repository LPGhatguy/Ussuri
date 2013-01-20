--[[
Action Delay
Delays an action to occur at a later time
]]

local delay = {}

delay.delay_time = 0
delay.delay_elapsed = 0
delay.delay_set = true

delay.event = {
	update = function(self, event)
		event.unhook = self:delay_step(event.delta)
	end
}

delay.delay_step = function(self, delta)
	local elapsed = self.delay_elapsed + delta
	self.delay_elapsed = elapsed

	if (elapsed >= self.delay_time and self.delay_set) then
		self.delay_set = false
		return self:delay_action()
	end
end

delay.delay_reset = function(self)
	self.delay_elapsed = 0
	self.delay_set = true
end

delay.new = function(self, delay, action)
	local new = self:_new()

	new.delay_time = delay or new.delay_time
	new.delay_action = action or new.delay_action

	return new
end

delay.init = function(self, engine)
	self.delay_action = engine.lib.utility.do_nothing

	engine.lib.oop:objectify(self)

	return self
end

return delay