local engine = require("engine.core")
local lib, extend
local state = true

function love.load()
	engine:init()
	local lib = engine.lib
	local extend = lib.extend

	engine:event_hook("update", extend.delay(0.2, function(self)
		state = not state
		self:delay_reset()
	end))

	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			event.cancel = true
			love.event.push("quit")
		end
	end)

	engine:event_hook("draw", function(self)
		if (state) then
			love.graphics.rectangle("fill", 100, 100, 50, 50)
		end
	end)
end

function love.keypressed(key, unicode)
	engine:fire_keydown(key, unicode)
end

function love.update(delta)
	engine:fire_update(delta)
end

function love.draw()
	engine:event_trigger("draw")
end

function love.quit()
	engine:close()
end