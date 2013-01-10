--[[
Shorthand Utilities
Used in console commands for quick debugging and execution -- don't use these in real library additions... please
The commands created here are slow and not meant for anything except the console
Written by Lucien Greathouse
]]

local engine
local lib
_ = {}

_.init = function(self, engine)
	lib = engine.lib
	_ = engine

	local tpop = lib.utility.table_pop

	setmetatable(engine, {
		__call = function(self)
			return self.lib
		end,
		__add = function(self, message)
			self:log_write(type(message) == "table" and unpack(message) or message)
		end,
		__sub = function(self, arg)
			self:log_pop(arg)
		end,
		__mul = function(self, arg)
			local count = tpop(arg)
			local method = tpop(arg)

			for i = 1, count do
				method(i, unpack(arg))
			end
		end,
		__pow = function(self, arg)
			local count = tpop(arg)
			local method = tpop(arg)

			for i = 1, count do
				method(unpack(arg))
			end
		end
	})

	return self
end

return _