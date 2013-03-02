--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local drawer = {
		event = {
			draw = function(self)
				love.graphics.rectangle("fill", 50, 50, 50, 50)
			end,
			joydown = function(self, event)
				print("Player", event.joystick, "pressed", event.button)
			end,
		}
	}

	ussuri:event_hook(nil, drawer)

	ussuri:event_hook(nil, lib.debug.header)
	ussuri:event_hook(nil, lib.debug.monitor)
	ussuri:event_hook(nil, lib.debug.console)
end