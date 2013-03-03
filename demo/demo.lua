--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	ussuri:event_hook(nil, lib.debug.header)
	ussuri:event_hook(nil, lib.debug.monitor)
	ussuri:event_hook(nil, lib.debug.console)
end