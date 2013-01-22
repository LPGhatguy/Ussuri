--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local machine = lib.misc.state_machine:new()
	machine.handlers = {
		["menu"] = {
			draw = function(self)
				love.graphics.rectangle("fill", 50, 50, 50, 50)
			end,
			keydown = function(self, event)
				if (event.key == " ") then
					self.state = "game"
				elseif (event.key == "escape") then
					ussuri:quit()
				end
			end
		},
		["game"] = {
			draw = function(self)
				love.graphics.rectangle("fill", 100, 100, 100, 100)
			end,
			keydown = function(self, event)
				if (event.key == "escape") then
					self.state = "menu"
				end
			end
		}
	}

	machine.state = "menu"
	ussuri:event_hook_batch({"draw", "keydown"}, machine)

	ussuri:event_hook_auto(ussuri.lib.debug.header)
	ussuri:event_hook_auto(ussuri.lib.debug.debug_monitor)
	ussuri:event_hook_auto(ussuri.lib.debug.console)
end