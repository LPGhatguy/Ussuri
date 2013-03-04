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

	local container2 = container:new()
	container2.x = 300

	local button = lib.ui.button:new()
	button.width = 50
	button.height = 50
	button.x = 190
	button.y = 50
	button.border_color = {255, 255, 255}

	button.event_mousedown:connect(function(self, event)
		local pos_x, pos_y = self:get_absolute_position(event.stack)

		ussuri:log_writes("yellow", "abs mouse:", event.abs_x, event.abs_y, "local mouse:", event.x, event.y)
		ussuri:log_write("yellow", "abs pos:", pos_x, pos_y, "local pos:", self.x, self.y)
	end)

	container:add(button)
	container2:add(button)

	ussuri:event_hook(nil, container)
	ussuri:event_hook(nil, container2)

	ussuri:event_hook(nil, lib.debug.header)
	ussuri:event_hook(nil, lib.debug.monitor)
	ussuri:event_hook(nil, lib.debug.console)
end