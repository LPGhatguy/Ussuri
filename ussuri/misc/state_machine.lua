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