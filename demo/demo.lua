--[[
Ussuri Demo
A small silly demo of the engine's capabilities
Written by Lucien Greathouse
]]

local lib, misc
local engine = require("engine")

function love.load()
	love.graphics.setBackgroundColor(0, 70, 150)

	print = function(...)
		engine:log_writes("out", ...)
	end

	lib = engine.lib
	misc = lib.misc

	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			if (love.keyboard.isDown("lshift")) then
				print((lib.utility.table_tree(lib)))
				engine.config.log_recording_enabled = true
			end

			event.cancel = true
			love.event.push("quit")
		end
	end, nil, -1)

	engine:event_hook_auto(lib.debug.debug_monitor)
	engine:event_hook_auto(lib.debug.console)

	local sound = misc.sound_manager:new()

	sound:disable_sound()
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
end

