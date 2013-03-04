--[[
Event Definitions
Extends the generic event model by adding LÖVE-specific events to fire
]]

local definitions

definitions = {
	fire_keydown = function(self, key, unicode)
		return self:event_trigger("keydown", {
			key = key,
			unicode = unicode
		})
	end,

	fire_keyup = function(self, key)
		return self:event_trigger("keyup", {
			key = key
		})
	end,

	fire_mousedown = function(self, x, y, button)
		return self:event_trigger("mousedown", {
			x = x,
			abs_x = x,
			y = y,
			abs_y = y,
			button = button
		})
	end,

	fire_mouseup = function(self, x, y, button)
		return self:event_trigger("mouseup", {
			x = x,
			abs_x = x,
			y = y,
			abs_y = y,
			button = button
		})
	end,

	fire_joydown = function(self, joystick, button)
		return self:event_trigger("joydown", {
			joystick = joystick,
			button = button
		})
	end,

	fire_joyup = function(self, joystick, button)
		return self:event_trigger("joyup", {
			joystick = joystick,
			button = button
		})
	end,

	fire_focus = function(self, focus)
		return self:event_trigger("focus", {
			focus = focus
		})
	end,

	fire_update = function(self, delta)
		return self:event_trigger("update", {
			delta = delta
		})
	end,

	fire_draw = function(self)
		return self:event_trigger("draw")
	end,

	fire_quit = function(self)
		return self:event_trigger("quit")
	end,

	init = function(self, engine)
		engine:event_create({"update", "draw", "quit", "focus",
			"keydown", "keyup", "joydown", "joyup", "mousedown", "mouseup"})

		engine:inherit(self)
	end,

	close = function(self, engine)
		engine:fire_quit()
	end
}

return definitions