--[[
Shorthand Utilities
Used in console commands for quick debugging and execution -- don't use these in real library additions... please
The commands created here are slow and not meant for anything except the console
]]

local engine
local lib, tpop
_ = {}

local meta = {}

meta.__call = function(self)
	self = self or engine

	return self.lib
end

meta.__add = function(self, message)
	if (message) then
		self:log_writes("green", type(message) == "table" and unpack(message) or message)
	end
end

meta.__sub = function(self, arg)
	arg = tonumber(arg) or 1

	for i = 1, arg do
		self:log_pop(arg)
	end
end

meta.__mul = function(self, arg)
	local count = tpop(arg)
	local method = tpop(arg)

	for i = 1, count do
		method(i, unpack(arg))
	end
end

meta.__pow = function(self, arg)
	local count = tpop(arg)
	local method = tpop(arg)

	for i = 1, count do
		method(unpack(arg))
	end
end

_.init = function(self, engine)
	lib = engine.lib
	_ = engine

	tpop = lib.utility.table_pop

	setmetatable(engine, meta)

	return self
end

return _