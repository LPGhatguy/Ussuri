local delayed = {}

delayed.delay_time = 0
delayed.delay_elapsed = 0
delayed.delay_set = true

delayed.delay_step = function(self, delta)
	local elapsed = self.delay_elapsed + delta
	self.delay_elapsed = elapsed

	if (elapsed >= self.delay_time) then
		self:delay_action()
	end
end

delayed.new = function(self, delay, action)
	local new = self:_new()

	new.delay_time = delay or new.delay_time
	new.delay_action = action or new.delay_action

	return new
end

delayed.delay_reset = function(self)
	self.delay_elapsed = 0
	self.delay_set = true
end

delayed.init = function(self, engine)
	self.delay_action = engine.lib.utility.do_nothing

	engine.lib.oop:objectify(self)

	return self
end

return delayed