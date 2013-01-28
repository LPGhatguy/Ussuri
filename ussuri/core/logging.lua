--[[
Logging System
Enables logging both in realtime and to logfiles
]]

local lib, config
local logging

logging = {
	log_history = {},

	log_write = function(self, ...)
		local out = {}
		for key, value in next, {...} do
			out[key] = tostring(value) or "nil"
		end

		local add = table.concat(out, " ")

		if (config.log_history_enabled) then
			table.insert(self.log_history, add)
		end

		if (config.log_realtime_enabled) then
			print(self:log_strip_style(add))
		end
	end,

	log_writes = function(self, style, ...)
		self:log_write("\b" .. style .. "\b", ...)
	end,

	--this method's existence is problematic:
	--it depends on ideas in the 'gui' module
	--in the future, other modules will add behavior
	log_strip_style = function(self, text)
		local out = text:gsub("\b.-\b", "")
		return out
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

	log_clear = function(self)
		self.log_history = {}
	end,

	log_pop = function(self)
		return lib.utility.table_pop(self.log_history, #self.log_history - 1)
	end,

	init = function(self, engine)
		lib = engine.lib
		config = engine.config or config

		engine:inherit(self)
		engine:log_write("Start:", engine.start_date)
		engine:log_write("Using engine version " .. tostring(engine.config.version))

		return self
	end,

	close = function(self, engine)
		engine:log_write("End:", engine.end_date)

		if (config.log_recording_enabled) then
			engine:log_record(engine.start_date:gsub("[:/ ]", "."))
		end
	end
}

return logging