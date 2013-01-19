--[[
Stateless Event System
Enables stateless event control and runtime determined handler fallthrough
Written by Lucien Greathouse
]]

local event_manage = {}
local lib = {}
local engine

event_manage.events = {}
event_manage.event_auto_sort = true

--overridable event internal utility methods

event_manage.event_handler_sorter = function(first, second)
	return (first[3] or 500) < (second[3] or 500)
end

event_manage.event_get_handler = function(object, handler, event_name)
	return handler or (type(object) == "table") and ((object.event and object.event[event_name]) or object[event_name]) or object
end

event_manage.event_get_priority = function(priority, object, event_name)
	return ((type(priority) == "table") and priority[event_name]) or
		((type(priority) == "number") and priority) or
		((type(object) == "table") and (object["event_priority"] and object["event_priority"][event_name]))
end

--event methods

event_manage.event_sort_handlers = function(self, event_name)
	if (event_name) then
		table.sort(self.events[event_name], self.event_handler_sorter)
	else
		for name, handlers in next, self.events do
			table.sort(handlers, self.event_handler_sorter)
		end
	end
end

event_manage.event_create = function(self, event_name)
	local event = self.events[event_name]

	event = event or {}
	event.pass = event.pass or self.event_pass:new()

	self.events[event_name] = event
end

event_manage.event_create_batch = function(self, ...)
	for key, event_name in next, {...} do
		self:event_create(event_name)
	end
end

event_manage.event_hook_start = function(self)
	self.event_auto_sort = false
end

event_manage.event_hook_end = function(self)
	self.event_auto_sort = true
	self:event_sort_handlers()
end

event_manage.event_hook = function(self, event_name, object, handler, priority)
	local handler = self.event_get_handler(object, handler, event_name)
	local priority = self.event_get_priority(priority, object, event_name)
	local handlers = self.events[event_name]

	if (object) then
		table.insert(handlers, {object, handler, tonumber(priority)})
	end

	if (self.event_auto_sort) then
		self:event_sort_handlers(event_name)
	end
end

event_manage.event_hook_auto = function(self, object, priority)
	if (type(object) == "table") then
		local methods = object.event or object

		for name, handler in next, methods do
			table.insert(self.events[name], {object, handler, self.event_get_priority(priority, object, name)})
		end
	elseif (type(object) == "function") then
		for event_name, event in next, self.events do
			table.insert(event, {object, object, priority})
		end
	end

	if (self.event_auto_sort) then
		self:event_sort_handlers()
	end
end

event_manage.event_hook_batch = function(self, handlers, object, priority)
	if (type(handlers) == "table") then
		for handler_id, handler_name in next, handlers do
			self:event_hook(handler_name, object, nil, priority)
		end
	else
		self:event_hook_auto(object, priority or handlers) --handlers is passed as priority instead
	end
end

event_manage.event_trigger = function(self, event_name, arguments)
	local handlers = self.events[event_name]
	local event_pass = handlers.pass:update(arguments)

	for key, handler in next, handlers do
		local object = handler[1]
		local method = handler[2]

		if (type(method) == "function") then
			method(object, event_pass)

			if (event_pass.unhook) then
				event_pass.unhook = false
				table.remove(handlers, key)
			end

			if (event_pass.cancel) then
				break
			end
		end
	end

	return event_pass
end

event_manage.event_get_pass = function(self, event_name)
	return self.events[event_name].pass
end

event_manage.event_pass = {}
event_manage.event_pass.new = function(self, arguments)
	local pass = self:_new()

	if (arguments) then
		for key, value in next, arguments do
			pass[key] = value
		end
	end

	pass.cancel = false

	return pass
end

event_manage.event_pass.update = function(self, arguments)
	if (arguments) then
		for key, value in next, arguments do
			self[key] = value
		end
	end

	self.cancel = false

	return self
end

event_manage.init = function(self, engine)
	lib = engine.lib

	lib.oop:objectify(self.event_pass, true)
	engine:inherit(self)

	return self
end

event_manage.close = function(self, engine)
	engine:event_trigger("quit")
end

return event_manage