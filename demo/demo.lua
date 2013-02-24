--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib
	local utility = lib.utility
	local debug = lib.debug
	local ui = lib.ui

	love.graphics.setMode(400, 400)

	local container = ui.frame:new()
	container.x = 50
	container.y = 50
	container.width = 300
	container.height = 300

	local button = ui.button:new()
	button.x = 50
	button.y = 50
	button.width = 50
	button.height = 50
	button.event_mousedown:register(function(self)
		ussuri:log_write("clicked!")
	end)
	container:add(button)

	ussuri:event_hook(nil, container)
	ussuri:event_hook(nil, debug.header)
	ussuri:event_hook(nil, debug.monitor)
	ussuri:event_hook(nil, debug.console)
end