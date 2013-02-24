--[[
Logging System
Enables logging both in realtime and to logfiles
]]

local lib, config
local logging

logging = {
	log_history = {},

	log_write = function(self, ...)
		local out = {...}
		for key = 1, #out do
			out[key] = tostring(out[key])
		end

		local add = table.concat(out, " ")

		if (config.log_history_enabled) then
			table.insert(self.log_history, add)
		end

		if (config.log_realtime_enabled) then
			self:log_report(add)
		end
	end,

	log_report = function(self, ...)
		print(...)
	end,

	log_clear = function(self)
		self.log_history = {}
	end,

	log_pop = function(self)
		return lib.utility.table_pop(self.log_history, #self.log_history - 1)
	end,

	log_record = function(self, filename)
		if (not love.filesystem.exists(config.log_directory)) then
			love.filesystem.mkdir(config.log_directory)
		end

		local file_out = love.filesystem.newFile(config.log_directory .. "/" .. filename .. ".txt")
		file_out:open("w")

		local to_write = ""
		for key, line in next, self.log_history do
			to_write = to_write .. self:log_strip_style(tostring(line):gsub("\n", "\r\n")) .. "\r\n"
		end

		file_out:write(to_write)

		file_out:close()
	end,

	init = function(self, engine)
		lib = engine.lib
		config = engine.config or config

		engine:inherit(self)
		engine:log_write("Start:", engine.start_date)
		engine:log_write("Using engine version " .. tostring(engine.config.version))
	end,

	close = function(self, engine)
		engine:log_write("End:", engine.end_date)

		if (config.log_recording_enabled) then
			engine:log_record(engine.start_date:gsub("[:/ ]", "."))
		end
	end
}

return logging