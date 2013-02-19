--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib
	local utility = lib.utility
	local debug = lib.debug
	local gui = lib.gui

	local container = gui.frame:new()
	container.x = 50
	container.y = 50
	container.width = 300
	container.height = 300

	local button = gui.button:new()
	button.x = 50
	button.y = 50
	button.width = 50
	button.height = 50
	button.event_mousedown = button.event_mousedown + function(self)
		print("clicked!")
	end
	container:add(button)

	ussuri:event_hook(nil, container)
	ussuri:event_hook(nil, debug.header)
	ussuri:event_hook(nil, debug.monitor)
	ussuri:event_hook(nil, debug.console)
end