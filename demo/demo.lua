--[[
Ussuri Demo
A small demo of the engine's capabilities
Written by Lucien Greathouse
]]

local lib, misc
local engine = require("engine")

function love.load()
	love.graphics.setBackgroundColor(0, 70, 150)

	lib = engine.lib
	misc = lib.misc

	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			if (love.keyboard.isDown("lshift")) then
				engine:log_write((lib.utility.table_tree(lib)))
				engine.config.log_recording_enabled = true
			end

			event.cancel = true
			love.event.push("quit")
		end
	end, nil, -1)

	engine:event_hook_auto(lib.debug.debug_monitor)
	engine:event_hook_auto(lib.debug.console)
end