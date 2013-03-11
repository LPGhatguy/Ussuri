--[[
Stateless Event System
Enables stateless event control
]]

local lib, engine
local event_manage

local handler_compare = function(first, second)
	return first[3] < second[3]
end

event_manage = {
	events = {},

	event_create = function(self, event_name, data)
		local events = self.events

		if (type(event_name) == "table") then
			for key = 1, #event_name do
				local name = tostring(event_name[key])

				if (not events[name]) then
					events[name] = {
						pass = self.event_pass:new(data)
					}
				end
			end
		else
			event_name = tostring(event_name)

			if (not events[event_name]) then
				events[event_name] = {
					pass = self.event_pass:new(data)
				}
			end
		end
	end,

	event_destroy = function(self, event_name)
		if (type(event_name) == "table") then
			for key = 1, #event_name do
				self.events[tostring(event_name[key])] = nil
			end
		else
			self.events[tostring(event_name)] = nil
		end
	end,

	event_trigger = function(self, event_name, data)
		local event = self.events[event_name]

		if (event) then
			local pass = event.pass
			pass:refurbish(data)

			for key = 1, #event do
				local handler = event[key]
				local object, method = handler[1], handler[2]

				method(object, pass)

				if (pass.unhook) then
					event[key] = nil
					pass.unhook = false
				end

				if (pass.cancel) then
					break
				end
			end

			return pass
		end
	end,

	event_sort = function(self, event_name)
		local events = self.events

		if (type(event_name) == "table") then
			for key, name in next, event_name do
				local event = events[name]

				if (event) then
					table.sort(event, handler_compare)
				end
			end
		elseif (event_name) then
			local event = events[name]

			if (event) then
				table.sort(event, handler_compare)
			end
		else
			for key, event in next, self.events do
				table.sort(event, handler_compare)
			end
		end
	end,

	event_hook = function(self, event_name, object, method, priority, no_sort)
		if (type(event_name) == "table") then
			for key = 1, #event_name do
				self:event_hook(event_name[key], object, method, priority, true)
			end
		elseif (event_name) then
			event_name = tostring(event_name)

			local event = self.events[event_name]
			if (event) then
				if (type(priority) == "table") then
					priority = tonumber(priority[event_name])
				else
					priority = tonumber(priority)
				end

				if (type(object) == "function") then
					table.insert(event, {
						{},
						object,
						priority or 0
					})
				elseif (type(object) == "table") then
					table.insert(event, {
						object,
						method or (object.event and object.event[event_name]),
						priority or (object.event_priority and object.event_priority[event_name]) or 0
					})
				end
			end
		else
			if (type(object) == "table") then
				if (object.event) then
					if (method) then
						for event_name in next, object.event do
							local event = self.events[tostring(event_name)]

							if (event) then
								table.insert(event, {
									object,
									method,
									priority or (object.event_priority and object.event_priority[event_name]) or 0
								})
							end
						end
					else
						for event_name, event_method in next, object.event do
							local event = self.events[tostring(event_name)]

							if (event) then
								table.insert(event, {
									object,
									event_method,
									priority or (object.event_priority and object.event_priority[event_name]) or 0
								})
							end
						end
					end
				end
			end
		end

		if (not no_sort) then
			self:event_sort()
		end
	end,

	event_hook_batch = function(self, event_name, objects, method, priority)
		for key = 1, #objects do
			self:event_hook(event_name, objects[key], method, priority)
		end
	end,

	event_pass = {
		stack = {},

		new = function(self, data)
			return self:_new():refurbish(data)
		end,

		refurbish = function(self, data)
			if (data) then
				for key, value in next, data do
					self[key] = value
				end
			end

			self.stack = {[0] = event_manage}
			self.cancel = false
			self.up = event_manage

			return self
		end
	},

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self.event_pass, true)
		engine:inherit(self)
	end
}

return event_manage