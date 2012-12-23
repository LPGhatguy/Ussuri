local event = {}
local lib = {}
local engine

event.events = {}

event.event_handler_sorter = function(first, second)
	return (first[3] or 0) > (second[3] > 0)
end

event.event_sort_handlers = function(self, event_name)
	if (event_name) then
		table.sort(self.events[event_name], self.event_handler_sorter)
	else
		for name, handlers in next, self.events do
			table.sort(handlers, self.event_handler_sorter)
		end
	end
end

event.event_create = function(self, event_name)
	self.events[event_name] = self.events[event_name] or {}
end

event.event_create_batch = function(self, ...)
	for key, event_name in next, {...} do
		self:event_create(event_name)
	end
end

event.event_hook_auto = function(self, object, priority)
	local object_type = type(object)

	if (object_type == "table") then
		local methods = object.event or object

		for name, handler in next, methods do
			table.insert(event, {object, handler, priority})
		end
	elseif (object_type == "function") then
		for event_name, event in next, self.events do
			table.insert(event, {object, object, priority})
		end
	end
end

event.event_hook_batch = function(self, object, handlers, priority)
	if (type(handlers) == "table") then
		for handler_id, handler_name in next, handlers do
			self:event_hook(handler_name, object, nil, priority)
		end
	else
		self:event_hook_auto(object, priority or handlers) --handlers is passed as priority instead
	end
end

event.event_hook = function(self, event_name, object, handler, priority)
	local handler = handler or (type(object) == "table") and ((object.event and object.event[event_name]) or object[event_name]) or object
	local handlers = self.events[event_name] or {}
	self.events[event_name] = handlers

	if (object) then
		table.insert(handlers, {object, handler, priority or 0})
	end
end

event.event_trigger = function(self, event_name, arguments)
	local event_pass = self.event_pass:new(event_name, arguments)
	local handlers = self.events[event_name]

	if (handlers) then
		for key, handler in next, handlers do
			local object = handler[1]
			local method = handler[2]

			if (type(method) == "function") then
				method(object, event_pass)

				if (event_pass.cancel) then
					break
				end
			end
		end
	else
		if (self.__logger) then
			self:log_write("Could not find event", event_name)
		end
	end

	return event_pass
end

event.event_pass = {}
event.event_pass.new = function(self, event_name, arguments)
	local pass = self:_new()

	if (arguments) then
		for key, value in next, arguments do
			pass[key] = value
		end
	end

	pass.cancel = false

	return pass
end

event.init = function(self, engine)
	lib = engine.lib

	lib.oop:objectify(self.event_pass, true)
	engine:inherit(self)

	return self
end

event.close = function(self, engine)
end

return event