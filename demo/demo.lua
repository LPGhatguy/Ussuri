--[[
Ussuri Demo
A small demo of Ussuri's capabilities
Written by Lucien Greathouse
]]

local ussuri = require("ussuri")

function love.load()
	ussuri:event_hook_auto(ussuri.lib.debug.header)
	ussuri:event_hook_auto(ussuri.lib.debug.debug_monitor)
	ussuri:event_hook_auto(ussuri.lib.debug.console)
end