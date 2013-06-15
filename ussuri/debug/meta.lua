--[[
Ussuri Meta
Gives information about the engine and its workings
]]

local lib
local stat

stat = {
	init = function(self, engine)
		lib = engine.lib
	end
}

return stat