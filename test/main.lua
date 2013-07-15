--[[
Ussuri 1.4.1 Test
]]

local ussuri = require("ussuri")

ussuri.start = function(engine, args)
	local lib = ussuri.lib

	local ui_root = lib.ui.ui_container:new()

	local drag = lib.ui.draggable:new(nil, 50, 50, 50, 50)

	ui_root:add(drag)

	ussuri.event:event_hook_object(nil, ui_root)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end