--[[
Shorthand Utilities
Used in console commands for quick debugging and execution -- don't use these in real library additions... please
The commands created here are slow and not meant for anything except the console
]]

local lib, engine, table_pop
local meta

meta = {
	__call = function(self)
		self = self or engine

		return self.lib
	end,

	__add = function(self, message)
		if (message) then
			self:log_writes("green", (type(message) == "table") and unpack(message) or message)
		end
	end,

	__sub = function(self, arg)
		arg = tonumber(arg) or 1

		for i = 1, arg do
			self:log_pop(arg)
		end
	end,

	__mul = function(self, arg)
		local count = table_pop(arg)
		local method = table_pop(arg)

		for i = 1, count do
			method(i, unpack(arg))
		end
	end,

	__pow = function(self, arg)
		local count = table_pop(arg)
		local method = table_pop(arg)

		for i = 1, count do
			method(unpack(arg))
		end
	end
}

_ = {
	init = function(self, engine)
		lib = engine.lib
		_ = engine

		table_pop = lib.utility.table_pop

		setmetatable(engine, meta)

		return self
	end
}

return _