local event = {}
local lib = {}
local engine

event.events = {}
event.events_light = {}

event.event_get_handler_func = function(handler, event_name)
	return handler["event_" .. event_name] or (handler.event and handler.event[event_name])
end

event.dict_to_array = function(dictionary)
	local array = {}
	local key = 1
	for key, value in pairs(dictionary) do
		array[key] = value
		key = key + 1
	end
	return array
end

event.event_hook = function(self, event_name, handler, priority)
	local handlers = self.events[event_name] or {}
	self.events[event_name] = handlers

	if (handler) then
		table.insert(handlers, priority or handler)
	end
end

event.event_hook_light = function(self, event_name, handler, priority)
	local handlers = self.events_light[event_name] or {}
	self.events_light[event_name] = handlers

	if (handler) then
		table.insert(handlers, priority or handler)
	end
end

event.event_trigger = function(self, event_name, arguments)
	if (self.events_light[event_name]) then
		self:event_trigger_light(event_name, arguments)
	end

	if (self.events[event_name]) then
		self:event_trigger_full(event_name, arguments)
	end
end

event.event_trigger_full = function(self, event_name, arguments)
	local event_pass = self.event_pass:new(event_name, arguments)
	local handlers = self.events[event_name]

	if (handlers) then
		for key, handler in next, handlers do
			if (type(handler) == "function") then
				handler(handler, event_pass)
			elseif (type(handler) == "table") then
				local handler_func = self.event_get_handler_func(handler, event_name)

				if (handler_func) then
					handler_func(handler, event_pass)
				else
					if (self.__logger) then
						self:log_write("Could not find handler for", key, "of full event", event_name)
					end
				end
			else
				if (self.__logger) then
					self:log_write("Unsupported handler type:", type(handler), "for", key, "of full event", event_name)
				end
			end

			if (event_pass.cancel) then
				break
			end
		end
	else
		if (self.__logger) then
			self:log_write("Could not find full event", event_name)
		end
	end
end

event.event_trigger_light = function(self, event_name, arguments)
	local handlers = self.events_light[event_name]
	local arguments = arguments or {}

	if (handlers) then
		for key, handler in next, handlers do
			if (type(handler) == "function") then
				handler(handler, self.dict_to_array(arguments))
			elseif (type(handler) == "table") then
				local handler_func = self.event_get_handler_func(handler, event_name)

				if (handler_func) then
					handler_func(handler, self.dict_to_array(arguments))
				else
					if (self.__logger) then
						self:log_write("Could not find handler for", key, "of light event", event_name)
					end
				end
			else
				if (self.__logger) then
					self:log_write("Unsupported handler type:", type(handler), "for", key, "of light event", event_name)
				end
			end
		end
	else
		if (self.__logger) then
			self:log_write("Could not find light event", event_name)
		end
	end
end

event.event_pass = {}
event.event_pass.new = function(self, event_name, arguments)
	local pass = self:_new()

	lib.utility.table_merge(arguments, pass)
	pass.event_name = event_name
	pass.cancel = false

	return pass
end

event.init = function(self, engine)
	lib = engine.lib

	lib.oop:objectify(self.event_pass)
	engine:inherit(self)

	return self
end

event.close = function(self, engine)
end

return event