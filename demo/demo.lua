local engine = require("engine.core")
local out = ""
local no_draw = {
	[0] = true,
	[27] = true,
	[8] = true
}
local transform = {
	["return"] = "\n"
}

function love.load()
	engine:init()

	engine:event_hook("keypressed", function(self, event)
		if (transform[event.key]) then
			out = out .. transform[event.key]
			event.cancel = true
		end
	end)

	engine:event_hook("keypressed", function(self, event)
		engine:log_write("Key not transformed!")

		if (not no_draw[event.unicode]) then
			out = out .. string.char(event.unicode)
			event.cancel = true
		end
	end)

	engine:event_hook("keypressed", function(self, event)
		engine:log_write("Key not drawn!")

		if (event.key == "backspace") then
			out = out:sub(1, -2)
			event.cancel = true
		end
	end)

	engine:event_hook_light("draw", function(self)
		love.graphics.print(out, 10, 10)
	end)
end

function love.keypressed(key, unicode)
	if (key == "escape") then
		love.event.push("quit")
	end

	engine:event_trigger_full("keypressed", {
		key = key,
		unicode = unicode
	})
end

function love.draw()
	engine:event_trigger("draw")
end

function love.quit()
	engine:close()
end