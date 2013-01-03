--[[

]]

local lib, extend
local engine = require("engine")

function love.load()
	print = function(...)
		engine:log_writes("out", ...)
	end

	lib = engine.lib
	extend = lib.extend

	engine:event_hook("update", function(self)
		love.graphics.setColor(extend.color.hsv(127.5 + 127.5 * math.sin(love.timer.getMicroTime() / 3), 255, 255))
		love.graphics.rectangle("fill", 0, 0, 1024, 768)
	end)

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

	local song = sound:play_music("song", true)

	engine:event_hook("keydown", function(self, event)
		if (event.key == " ") then
			sound:play_effect("bloop")
		elseif (event.key == "lalt" or event.key == "ralt") then
			sound:toggle_sound()
		elseif (event.key == "return" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl"))) then
			love.graphics.toggleFullscreen()
		end
	end)

	engine:event_hook("draw", function()
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf("Press space to bloop, press alt to toggle sound", 0, 750, 1024, "center")
	end)
end

