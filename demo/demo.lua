local engine = require("engine.core")

function love.load()
	engine:init()

	love.graphics.setPointSize(1)

	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			event.cancel = true
			love.event.push("quit")
		end
	end)

	engine:event_hook("draw", function(self)
		love.graphics.print(love.timer.getDelta(), 10, 10)
	end)
end

function love.keypressed(key, unicode)
	engine:fire_keydown(key, unicode)
end

function love.draw()
	engine:event_trigger("draw")
end

function love.quit()
	engine:close()
end