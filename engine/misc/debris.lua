--[[
Standalone Debris Object
Use for single unique debris objects
Written by Lucien Greathouse
]]

local debris = {}

debris.debris_lifetime = 2
debris.debris_expended = 0
debris.debris_alive = true

debris.event = {
	update = function(self, event)
		event.unhook = self:debris_step(event.delta)
	end
}

debris.debris_step = function(self, delta)
	if (self.debris_alive) then
		local expended = self.debris_expended + delta
		self.debris_expended = expended

		if (expended > self.debris_lifetime) then
			self.debris_alive = false
			return not self:debris_destroy()
		else
			return self:debris_update()
		end
	end
end

debris.new = function(self, lifetime, update, destroy)
	local new = self:_new()

	new.debris_lifetime = lifetime or new.debris_lifetime
	new.debris_update = update or new.debris_update
	new.debris_destroy = destroy or new.debris_destroy

	return new
end

debris.init = function(self, engine)
	self.debris_update = engine.lib.utility.do_nothing
	self.debris_destroy = engine.lib.utility.do_nothing
	engine.lib.oop:objectify(self)

	return self
end

return debris