--[[
Event Object
A drop-in replacement for functions with multiple bodies
]]

local event = {}

event.handlers = {}

event.pre = function(self)
end

event.post = function(self)
end

event.call = function(self, ...)
	self:pre(...)

	for key, value in next, self.handlers do
		value(...)
	end

	self:post(...)

	return self
end

event.register = function(self, method)
	table.insert(self.handlers, method)

	return self
end

local meta = {
	__call = event.call,
	__add = event.register
}

event.init = function(self, engine)
	setmetatable(self, meta)
	engine.lib.oop:objectify(self)

	return self
end

return event