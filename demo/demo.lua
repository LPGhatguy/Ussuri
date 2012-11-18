local ld25_engine = require("engine.core")
ld25_engine:init()

function love.load()
	print(ld25_engine.lib.utility)
end

function love.keypressed(key, unicode)
	if (key == "escape") then
		love.event.push("quit")
	end
end