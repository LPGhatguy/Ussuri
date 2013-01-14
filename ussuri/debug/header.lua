local header = {}
local engine, lib
header.event_priority = {
	update = -1
}

header.event = {
	keydown = function(self, event)
		if (event.key == "escape") then
			event.cancel = true

			if (love.keyboard.isDown("lshift")) then
				engine.config.log_recording_enabled = true
				engine:log_write(lib.utility.table_tree(engine))
			end

			love.event.push("quit")
		end
	end
}

header.init = function(self, g_engine)
	engine = g_engine
	lib = engine.lib

	return self
end

return header