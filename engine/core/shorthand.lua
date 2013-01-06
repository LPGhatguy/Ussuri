--[[
Shorthand Utilities
Used in console commands for quick debugging and execution -- don't use these in real library additions... please
The commands created here are slow and not meant for anything legitimate
Written by Lucien Greathouse
]]

local engine
_ = {}

local tpop = function(from, index)
	local got = from[index or 1]
	table.remove(from, index or 1)

	return got
end

_.init = function(self, engine)
	_ = engine

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