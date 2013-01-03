--[[
Event Definitions
Extends the original event model by adding methods for event firing
Written by Lucien Greathouse
]]

local definitions = {}
local lib

definitions.fire_keydown = function(self, key, unicode)
	return self:event_trigger("keydown", {
		key = key,
		unicode = unicode
	})
end

definitions.fire_keyup = function(self, key)
	return self:event_trigger("keyup", {
		key = key
	})
end

definitions.fire_mousedown = function(self, x, y, button)
	return self:event_trigger("mousedown", {
		x = x,
		y = y,
		button = button
	})
end

definitions.fire_mouseup = function(self, x, y, button)
	return self:event_trigger("mouseup", {
		x = x,
		y = y,
		button = button
	})
end

definitions.fire_joydown = function(self, joystick, button)
	return self:event_trigger("joydown", {
		joystick = joystick,
		button = button
	})
end

definitions.fire_joyup = function(self, joystick, button)
	return self:event_trigger("joyup", {
		joystick = joystick,
		button = button
	})
end

definitions.fire_focus = function(self, focus)
	return self:event_trigger("focus", {
		focus = focus
	})
end

definitions.fire_update = function(self, delta)
	return self:event_trigger("update", {
		delta = delta
	})
end

definitions.fire_draw = function(self)
	return self:event_trigger("draw")
end

definitions.init = function(self, engine)
	lib = engine.lib

	engine:event_create_batch("update", "draw", "quit", "focus",
		"keydown", "keyup", "joydown", "joyup", "mousedown", "mouseup")
	engine:inherit(self)

	return self
end

return definitions