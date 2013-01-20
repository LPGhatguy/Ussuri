--[[
State Machine
A state machine with possible (but not critical) integration into Ussuri's event framework
]]

local state = {}
local lib

state.event = {}
state.states = {}
state.handlers = {}

state.init = function(self, engine)
	lib = engine.lib

	return self
end

return state