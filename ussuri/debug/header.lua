--[[
Debug Header
Intercepts Keystrokes to assist in speedy debugging
]]

local engine, lib
local header

header = {
	event_priority = {
		keydown = -1
	},

	event = {
		keydown = function(self, event)
			if (event.key == "tab" and love.keyboard.isDown("lctrl")) then
				event.cancel = true

				if (love.keyboard.isDown("lshift")) then
					engine.config.log_recording_enabled = true
					engine:log_write(lib.utility.table_tree(engine))
				end

				love.event.push("quit")
			end
		end
	},

	init = function(self, g_engine)
		engine = g_engine
		lib = engine.lib
	end
}

return header