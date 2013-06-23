--[[
Event Definitions
Implements LÖVE events into the standard Ussuri event stack
Monkey-patches engine.event
]]

local definitions

definitions = {
	fire_keydown = function(self, key, code)
		return self:event_fire("keydown", {
			key = key,
			code = code
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

		local engine_event = engine.event

		engine_event:event_create({"update", "draw", "quit", "focus",
			"keydown", "keyup", "joydown", "joyup", "mousedown", "mouseup",
			"display_updating", "display_updated"})

		engine_event:inherit(self)

		love.handlers = setmetatable({
			keypressed = function(b, u)
				if love.keypressed then
					love.keypressed(b, u)
				end
				engine_event:fire_keydown(b, u)
			end,

			keyreleased = function(b)
				if love.keyreleased then
					love.keyreleased(b)
				end
				engine_event:fire_keyup(b)
			end,

			mousepressed = function(x, y, b)
				if love.mousepressed then
					love.mousepressed(x, y, b)
				end
				engine_event:fire_mousedown(x, y, b)
			end,

			mousereleased = function(x, y, b)
				if love.mousereleased then
					love.mousereleased(x, y, b)
				end
				engine_event:fire_mouseup(x, y, b)
			end,

			joystickpressed = function(j, b)
				if love.joystickpressed then
					love.joystickpressed(j, b)
				end
				engine_event:fire_joydown(j, b)
			end,

			joystickreleased = function(j, b)
				if love.joystickreleased then
					love.joystickreleased(j, b)
				end
				engine_event:fire_joyup(j, b)
			end,

			focus = function(f)
				if love.focus then
					love.focus(f)
				end
				engine_event:fire_focus(f)
			end,

			quit = function()
				return
			end
			},
			{
			__index = function(self, name)
				error("Unknown event: " .. name)
			end
			}
		)
	end,

	close = function(self, engine)
		engine.event:fire_quit()
	end
}

return definitions