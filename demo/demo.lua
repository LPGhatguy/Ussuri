local engine = require("engine.core")

function love.load()
	engine:init()
end

function love.keypressed(key, unicode)
	if (key == "escape") then
		love.event.push("quit")
	end
end

function love.draw()
end

function love.quit()
	engine:close()
end