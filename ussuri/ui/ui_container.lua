--[[
UI Container
Holds UI objects and passes calls to them
]]

local lib
local container
local ui_base
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

	_new = function(base, new, x, y, w, h)
		container._new(base, new)
		ui_base._new(base, new, x, y, w, h)

		return new
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		ui_base = self:inherit(engine:lib_get("ui.base"))
		container = self:inherit(engine:lib_get("event.container"))
	end
}

return ui_container