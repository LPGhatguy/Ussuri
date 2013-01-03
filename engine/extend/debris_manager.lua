--[[
Debris Manager
Use for batch or lightweight debris objects
Written by Lucien Greathouse
]]

local debris_manager = {}

debris_manager.children = {}

debris_manager.event = {
	update = function(self, event)
		self:debrismanage_step(event.delta)
	end
}

debris_manager.debrismanage_step = function(self, delta)
	for child, time_left in next, self.children do
		local time_updated = time_left - delta

		if (time_updated <= 0) then
			self.children[child] = nil
			self:destroy_child(child)
		else
			self.children[child] = time_updated
			self:update_child(child, delta)
		end
	end
end

debris_manager.update_child = function(self, child, delta)
	if (type(child) == "table" and child["update"]) then
		child:update(self)
	end
end

debris_manager.destroy_child = function(self, child)
	if (type(child) == "table" and child["destroy"]) then
		child:destroy(self)
	end
	self.children[child] = nil
end

debris_manager.init = function(self, engine)
	engine.lib.oop:objectify(self)

	return self
end

return debris_manager