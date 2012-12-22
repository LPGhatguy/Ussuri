local debris_manager = {}

debris_manager.debrismanage_children = {}

debris_manager.debrismanage_step = function(self, delta)
	for child, time_left in next, self.debris_children do
		local time_updated = time_left - delta

		if (time_updated <= 0) then
			self.child[child] = nil
			self:destroy_child(child)
		else
			self.child[child] = time_updated
			self:update_child(child)
		end
	end
end

debris_manager.debrismanage_update_child = function(self, child)
	if (type(child) == "table" and child["update"]) then
		child:update(self)
	end
end

debris_manager.debrismanage_destroy_child = function(self, child)
	if (type(child) == "table" and destroy["update"]) then
		child:destroy(self)
	end
end

debris_manager.init = function(self, engine)
	engine.lib.oop:objectify(self)

	return self
end

return debris_manager