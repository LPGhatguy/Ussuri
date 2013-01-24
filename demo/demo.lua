--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local intro_graphic = love.graphics.newImage("demo/asset/image/intro_graphic.png")
	local title_graphic = love.graphics.newImage("demo/asset/image/title_graphic.png")

	local machine = lib.misc.state_machine:new()
	machine.handlers = {
		["intro"] = {
			state_changed = function(self)
				self.intro_time = 0
			end,
			draw = function(self)
				love.graphics.setColor(255, 255, 255)
				love.graphics.draw(intro_graphic, 0, 0)

				if (self.intro_time > 3) then
					self:set_state("title")
				end
			end,
			update = function(self, event)
				self.intro_time = self.intro_time + event.delta
			end
		},
		["title"] = {
			draw = function(self)
				love.graphics.setColor(255, 255, 255)

				love.graphics.draw(title_graphic, 0, 0)
				love.graphics.printf("Press space to continue...", 0, 740, 1024, "center")
			end,
			keydown = function(self, event)
				if (event.key == " ") then
					self:set_state("menu")
				end
			end
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

	machine:set_state("intro")
	ussuri:event_hook({"draw", "keydown", "update"}, machine, nil, 550)

	ussuri:event_hook(nil, ussuri.lib.debug.header)
	ussuri:event_hook(nil, ussuri.lib.debug.debug_monitor)
	ussuri:event_hook(nil, ussuri.lib.debug.console)
end