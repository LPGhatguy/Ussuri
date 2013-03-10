--[[
Ussuri Demo
A controller test for testing assistance in a future input library
Tailored for an Xbox 360 Controller
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	love.graphics.setFont(love.graphics.newFont())
	local mappings = {"A", "B", "X", "Y", "LB", "RB", "Back", "Start"}

	local drawer = {
		event = {
			draw = function(self)
				love.graphics.setLineWidth(4)

				love.graphics.setColor(255, 255, 255)
				love.graphics.circle("line", 200, 200, 100)
				love.graphics.circle("line", 200, 200, 15)
				love.graphics.circle("line", 450, 200, 100)
				love.graphics.circle("line", 450, 200, 15)

				love.graphics.setColor(0, 200, 0)
				love.graphics.circle("fill",
					200 + math.floor(love.joystick.getAxis(1, 1) * 90),
					200 + math.floor(love.joystick.getAxis(1, 2) * 90),
					10)

				love.graphics.circle("fill",
					450 + math.floor(love.joystick.getAxis(1, 5) * 90),
					200 + math.floor(love.joystick.getAxis(1, 4) * 90),
					10)


				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("line", 275, 350, 100, 300)
				love.graphics.rectangle("line", 175, 450, 300, 100)

				local hat = love.joystick.getHat(1, 1)
				love.graphics.setColor(0, 200, 0)

				if (hat:find("l")) then
					love.graphics.rectangle("fill", 175, 450, 100, 100)
				elseif (hat:find("u")) then
					love.graphics.rectangle("fill", 275, 350, 100, 100)
				elseif (hat:find("r")) then
					love.graphics.rectangle("fill", 375, 450, 100, 100)
				elseif (hat:find("d")) then
					love.graphics.rectangle("fill", 275, 550, 100, 100)
				end

				love.graphics.setLineWidth(2)
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle("line", 600, 100, 50, 200)
				love.graphics.line(600, 200, 650, 200)


				local triggers = love.joystick.getAxis(1, 3)

				if (triggers > 0) then
					love.graphics.setColor(200, 0, 0)
				elseif (triggers < 0) then
					love.graphics.setColor(0, 200, 0)
				end

				love.graphics.rectangle("fill", 600, 200, 50, 100 * triggers)

				local height = love.graphics.getFont():getHeight()

				for id, name in next, mappings do
					local down = love.joystick.isDown(1, id)

					if (down) then
						love.graphics.setColor(0, 200, 0)
					else
						love.graphics.setColor(200, 0, 0)
					end

					love.graphics.print((mappings[id] or "Button " .. id) .. ": " ..
						(down and "down" or "up") .. "\n", 4, height * id)
				end
			end
		}
	}

	ussuri:event_hook(nil, drawer)

	ussuri:event_hook(nil, lib.debug.header)
	ussuri:event_hook(nil, lib.debug.monitor)
	ussuri:event_hook(nil, lib.debug.console)
end