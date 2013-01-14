--[[
Ussuri Demo
A small demo of Ussuri's capabilities
Written by Lucien Greathouse
]]

local lib, misc
local ussuri = require("ussuri")

function love.load()
	love.graphics.setBackgroundColor(0, 70, 150)

	lib = ussuri.lib
	misc = lib.misc

	ussuri:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			if (love.keyboard.isDown("lshift")) then
				ussuri:log_write((lib.utility.table_tree(lib)))
				ussuri.config.log_recording_enabled = true
			end

			event.cancel = true
			love.event.push("quit")
		end
	end, nil, -1)

	ussuri:event_hook_auto(lib.debug.debug_monitor)
	ussuri:event_hook_auto(lib.debug.console)
end