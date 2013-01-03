local lib, extend
local engine = require("engine")

local fader = {
	time = 0,
	update = function(self, event)
		self.time = self.time + event.delta
	end,
	draw = function(self)
		love.graphics.setColor(extend.color.hsv(127.5 + 127.5 * math.sin(self.time / 3), 255, 255))
		love.graphics.rectangle("fill", 0, 0, 1024, 768)

		--[[
		love.graphics.setColor(extend.color.hsv(127.5 + 127.5 * math.sin(self.time / 5), 255, 255))
		love.graphics.rectangle("fill", 0, 0, 512, 384)

		love.graphics.setColor(extend.color.hsv(127.5 + 127.5 * math.sin(self.time / 4), 255, 255))
		love.graphics.rectangle("fill", 512, 0, 512, 384)

		love.graphics.setColor(extend.color.hsv(127.5 + 127.5 * math.sin(self.time / 6), 255, 255))
		love.graphics.rectangle("fill", 0, 384, 512, 384)

		love.graphics.setColor(extend.color.hsv(127.5 + 127.5 * math.sin(self.time / 7), 255, 255))
		love.graphics.rectangle("fill", 512, 384, 512, 384)
		]]
	end
}

function love.load()
	print = function(...)
		engine:log_writes("out", ...)
	end

	lib = engine.lib
	extend = lib.extend

	engine:event_hook_batch({"update", "draw"}, fader)

	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			if (love.keyboard.isDown("lctrl")) then
				engine.config.log_recording_enabled = true
			end

			event.cancel = true
			love.event.push("quit")
		end
	end, nil, -1)

	engine:event_hook_auto(lib.debug.debug_monitor)
	engine:event_hook_auto(lib.debug.console)

	local sound = extend.sound_manager:new()

	engine:event_hook_auto(sound)

	sound:load_effect("demo/resource/bloop.ogg")
	sound:load_music("demo/resource/song.ogg")

	sound:play_music("song", true)

	engine:event_hook("keydown", function(self, event)
		if (event.key == " ") then
			sound:play_effect("bloop")
		elseif (event.key == "lalt") then
			sound:toggle_play_music()
		elseif (event.key == "return" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl"))) then
			love.graphics.toggleFullscreen()
		end
	end)

	engine:event_hook("draw", function()
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf("Press space to bloop, press left alt to pause/play music", 0, 750, 1024, "center")
	end)
end

