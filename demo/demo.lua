--[[
Ussuri 1.3.0 Demo
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local container = lib.ui.ui_container:new(0, 0, 1024, 768)
	container.clip_children = false

	local subcont = lib.ui.frame:new(50, 0, 180, 200)

	local ui_item = lib.ui.button:new(50, 50, 50, 50)

	local image = lib.ui.image:new(love.graphics.newImage("demo/asset/fun_block.png"), 100, 50, 50, 50)

	container:add(subcont)
	subcont:adds({ui_item, image})

	ussuri.event:event_hook_object(nil, container)

	ussuri.event:event_hook_object(nil, lib.debug.header)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)

	ussuri.event:event_sort()
end