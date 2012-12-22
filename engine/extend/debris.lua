local debris = {}

debris.debris_lifetime = 2
debris.debris_expended = 0
debris.debris_alive = true

debris.debris_step = function(self, delta)
	if (self.debris_alive) then
		local expended = self.debris_expended + event.delta
		self.debris_expended = expended

		if (expended > self.debris_lifetime) then
			self:debris_destroy()
		else
			self:debris_update()
		end
	end
end

debris.debris_destroy = function(self)
	self.alive = false
end

debris.init = function(self, engine)
	self.debris_update = engine.lib.utility.do_nothing
	engine.lib.oop:objectify(self)

	return self
end

return debris