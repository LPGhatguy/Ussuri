--[[
Ussuri 1.2.0 Demo!
A demo with the new event model!
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local eventer = lib.event.handler:new()
	eventer:event_create({"draw", "keydown"})

	local rectangle

	rectangle = {
		event = {
			draw = function(self, event)
				love.graphics.rectangle("fill", 50, 50, 50, 50)
			end,

			keydown = function(self, event)
				print("You just pressed '" .. event.key .. "'!")
			end
		}
	}

	eventer:event_hook_object(nil, rectangle)

	ussuri.event:event_hook_object({"draw", "keydown"}, eventer)
	ussuri.event:event_hook_object(nil, lib.debug.header)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end