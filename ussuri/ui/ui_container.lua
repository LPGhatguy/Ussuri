--[[
UI Container
Holds UI objects and passes calls to them
]]

local lib
local container
local ui_container

ui_container = {
	auto_hook = {["draw"] = true},

	event = {
		draw = function(self, event)
			--todo: element clipping

			love.graphics.push()
			love.graphics.translate(self.x, self.y)

			self:event_fire("draw", event)

			love.graphics.pop()
		end
	},

	_new = function(self)
		local instance = container._new(self)

		for key, flag in pairs(self.auto_hook) do
			instance:event_create(key)
		end

		return instance
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		self:inherit(engine:lib_get("ui.base"))
		container = self:inherit(engine:lib_get("event.container"))
	end
}

return ui_container