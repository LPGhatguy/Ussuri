--[[
Ussuri 1.2.2 Demo!
Featuring UI elements!
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local container = lib.event.container:new()

	local ui_item = lib.ui.base:new()

	container:event_create("draw")
	container:add(ui_item)

	ussuri.event:event_hook_object("draw", container)

	ussuri.event:event_hook_object(nil, lib.debug.header)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end