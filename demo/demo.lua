--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib
	local utility = lib.utility
	local debug = lib.debug
	local gui = lib.gui

	love.graphics.setMode(604, 604)
	love.graphics.setBackgroundColor(100, 100, 100)

	local title_font = love.graphics.newFont(24)

	local fxf = gui.container:new()
	fxf.width = 50
	fxf.height = 50

	for x = 0, 4 do
		for y = 0, 4 do
			local box = gui.checkbox:new()
			box.x = 10 * x
			box.y = 10 * y

			fxf:add(box)
		end
	end

	local root = gui.frame:new()
	root.width = 504
	root.height = 504
	root.x = 50
	root.y = 50

	for x = 0, 9 do
		for y = 0, 9 do
			local container = fxf:new()
			container.x = 50 * x
			container.y = 50 * y

			root:add(container)
		end
	end

	ussuri:event_hook(nil, root)

	ussuri:event_hook("draw", function(self, event)
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(title_font)
		love.graphics.printf("UI Checkbox Demo", 0, 14, 604, "center")
		love.graphics.printf("Click boxes to fill/unfill them.", 0, 570, 604, "center")
	end)

	ussuri:event_hook(nil, debug.header)
	ussuri:event_hook(nil, debug.monitor)
	ussuri:event_hook(nil, debug.console)
end