--[[
Event Definitions
Implements LÖVE events into the standard Ussuri event stack
Monkey-patches engine.event (which is perfectly fine)
]]

local definitions

definitions = {
	fire_keydown = function(self, key, unicode)
		return self:event_fire("keydown", {
			key = key,
			unicode = unicode
		})
	end,

	fire_keyup = function(self, key)
		return self:event_fire("keyup", {
			key = key
		})
	end,

	fire_mousedown = function(self, x, y, button)
		return self:event_fire("mousedown", {
			x = x,
			abs_x = x,
			y = y,
			abs_y = y,
			button = button
		})
	end,

	fire_mouseup = function(self, x, y, button)
		return self:event_fire("mouseup", {
			x = x,
			abs_x = x,
			y = y,
			abs_y = y,
			button = button
		})
	end,

	fire_joydown = function(self, joystick, button)
		return self:event_fire("joydown", {
			joystick = joystick,
			button = button
		})
	end,

	fire_joyup = function(self, joystick, button)
		return self:event_fire("joyup", {
			joystick = joystick,
			button = button
		})
	end,

	fire_focus = function(self, focus)
		return self:event_fire("focus", {
			focus = focus
		})
	end,

	fire_update = function(self, delta)
		return self:event_fire("update", {
			delta = delta
		})
	end,

	fire_draw = function(self)
		return self:event_fire("draw", {})
	end,

	fire_quit = function(self)
		return self:event_fire("quit", {})
	end,

	fire_display_updating = function(self, width, height, fullscreen, vsync, fsaa)
		return self:event_fire("display_updating", {
			width = width,
			height = height,
			fullscreen = fullscreen,
			vsync = vsync
		})
	end,

	fire_display_updated = function(self, width, height, fullscreen, vsync, fsaa)
		return self:event_fire("display_updated", {
			width = width,
			height = height,
			fullscreen = fullscreen,
			vsync = vsync
		})
	end,

	init = function(self, engine)
		engine:lib_get(":event.handler")

		engine.event:event_create({"update", "draw", "quit", "focus",
			"keydown", "keyup", "joydown", "joyup", "mousedown", "mouseup",
			"display_updating", "display_updated"})

		engine.event:inherit(self)
	end,

	close = function(self, engine)
		engine.event:fire_quit()
	end
}

return definitions