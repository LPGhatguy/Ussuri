--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	ussuri.event:event_hook_object(nil, lib.debug.header)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end