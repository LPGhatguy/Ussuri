local engine = require("engine.core")

function love.load()
	engine:init()

	engine:event_hook("keypressed", function(self, event)
		if (event.key == "escape") then
			event.cancel = true
			love.event.push("quit")
		end
	end)
end

function love.keypressed(key, unicode)
	engine:event_trigger("keypressed", {key = key, unicode = unicode})
end

function love.draw()
	engine:event_trigger("draw")
end

function love.quit()
	engine:close()
end