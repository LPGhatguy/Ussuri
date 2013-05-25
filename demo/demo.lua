--[[
Ussuri 1.2.2 Demo!
Featuring UI elements!
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	container = lib.ui.ui_container:new()

	ui_item = lib.ui.rectangle:new(50, 50, 50, 50)

	container:add(ui_item)

	ussuri.event:event_hook_object("draw", container)

	ussuri.event:event_hook_object(nil, lib.debug.header)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end