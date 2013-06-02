--[[
Ussuri 1.2.2 Demo!
Featuring UI elements!
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local container = lib.ui.ui_container:new(50, 50, 1024, 768)

	local ui_item = lib.ui.button:new(50, 50, 50, 50)

	local image = lib.ui.image:new(love.graphics.newImage("demo/asset/fun_block.png"), 100, 50, 50, 50)

	container:adds({ui_item, image})

	ussuri.event:event_hook_object(nil, container)

	ussuri.event:event_hook_object(nil, lib.debug.header)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end