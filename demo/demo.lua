--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local container = lib.ui.frame:new()
	container.x = 50
	container.y = 50
	container.width = 200
	container.height = 200
	lib.debug.console.environment.container = container

	local textbox = lib.ui.textbox_multiline:new()
	container:register("textbox", textbox)

	ussuri:event_hook(nil, lib.debug.header)
	ussuri:event_hook(nil, lib.debug.monitor)
	ussuri:event_hook(nil, lib.debug.console)
end