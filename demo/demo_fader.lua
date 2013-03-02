--[[
Ussuri Demo
A small demo of Ussuri's capabilities
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib
	local utility = lib.utility

	local intro_graphic = love.graphics.newImage("demo/asset/image/intro_graphic.png")
	local title_graphic = love.graphics.newImage("demo/asset/image/title_graphic.png")

	local input = lib.input.input_manager:new()

	local fader = utility.state_queue:new()
	fader.color = {0, 0, 0, 255}
	fader.width = love.graphics.getWidth()
	fader.height = love.graphics.getHeight()

	fader.draw = function(self)
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", 0, 0, self.width, self.height)
	end

	fader.handlers = {
		["in"] = {
			draw = fader.draw,
			update = function(self, event)
				self.color[4] = 255 - (255 * (self.elapsed / self.time))
			end,
			state_changing = function(self)
				self.color[4] = 0
			end
		},
		["out"] = {
			draw = fader.draw,
			update = function(self, event)
				self.color[4] = 255 * (self.elapsed / self.time)
			end,
			state_changing = function(self)
				self.color[4] = 255
			end
		},
		["wait"] = {
			draw = fader.draw
		}
	}

	local machine = utility.state_machine:new()
	machine.handlers = {
		["intro"] = {
			state_changed = function(self)
				fader:queue({"wait", 1}, {"in", 1}, {"wait", 1}, {"out", 1},
					{"wait", 0.5, self.set_state, self, "title"})
			end,
			draw = function(self)
				love.graphics.setColor(255, 255, 255)
				love.graphics.draw(intro_graphic, 0, 0)
			end
		},
		["title"] = {
			state_changed = function(self)
				fader:queue({"in", 0.5})
			end,
			draw = function(self)
				love.graphics.setColor(255, 255, 255)

				love.graphics.draw(title_graphic, 0, 0)
				love.graphics.printf("Press space to continue...", 0, 740, 1024, "center")
			end,
			keydown = function(self, event)
				if (event.key == " ") then
					fader:queue({"out", 0.6}, {"in", 0.6, self.set_state, self, "menu"})
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
	ussuri:event_hook({"draw", "update"}, fader, nil, 551)
	ussuri:event_hook(nil, input)

	ussuri:event_hook(nil, lib.debug.header)
	ussuri:event_hook(nil, lib.debug.monitor)
	ussuri:event_hook(nil, lib.debug.console)
end