local IS_LOVE = (love and true)

local ld25_engine = require("engine.core")
ld25_engine:init()

function love.load()
	print(ld25_engine.config_get("engine_path"))
end

if (IS_LOVE) then

	function love.keypressed(key, unicode)
		if (key == "escape") then
			love.event.push("quit")
		end
	end

end