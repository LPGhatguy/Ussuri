--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local intro_graphic = love.graphics.newImage("demo/asset/image/intro_graphic.png")

	local machine = lib.misc.state_machine:new()
	machine.state = "intro"
	machine.intro_time = 0
	machine.handlers = {
		["intro"] = {
			draw = function(self)
				love.graphics.setColor(255, 255, 255)
				love.graphics.draw(intro_graphic, 0, 0)

				if (self.intro_time < 2) then
					love.graphics.setColor(0, 0, 0, math.max((255 - (255 * (self.intro_time ^ 2))), 0))
				elseif (self.intro_time < 4) then
					love.graphics.setColor(0, 0, 0, (255 * ((self.intro_time - 2) / 2)))
				elseif (self.intro_time < 5) then
					love.graphics.setColor(0, 0, 0)
				else
					love.graphics.setColor(0, 0, 0)
					self:set_state("menu")
				end

				love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
			end,
			update = function(self, event)
				self.intro_time = self.intro_time + event.delta
			end,
		},
		["menu"] = {
			draw = function(self)
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", 50, 50, 50, 50)
			end,
			keydown = function(self, event)
				if (event.key == " ") then
					self:set_state("game")
				elseif (event.key == "escape") then
					ussuri:quit()
				end
			end
		},
		["game"] = {
			draw = function(self)
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("fill", 100, 100, 100, 100)
			end,
			keydown = function(self, event)
				if (event.key == "escape") then
					self:set_state("menu")
				end
			end
		}
	}

	ussuri:event_hook_batch({"draw", "keydown", "update", "quit"}, machine)

	ussuri:event_hook_auto(ussuri.lib.debug.header)
	ussuri:event_hook_auto(ussuri.lib.debug.debug_monitor)
	ussuri:event_hook_auto(ussuri.lib.debug.console)
end