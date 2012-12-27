local logging = {}
local print = print
local config
logging.log_history = {}
logging.log_strung = ""
logging.__logger = true

logging.log_write = function(self, ...)
	local add = ""
	for key, value in pairs({...}) do
		add = add .. " " .. tostring(value):gsub("\n", "\r\n")
	end

	if (config.log_history_enabled) then
		table.insert(self.log_history, add)
		self.log_strung = self.log_strung .. "\n" .. add
	end

	if (config.log_realtime_enabled) then
		print(add)
	end
end

logging.log_record = function(self, filename)
	if (not love.filesystem.exists(config.log_directory)) then
		love.filesystem.mkdir(config.log_directory)
	end

	local file_out = love.filesystem.newFile(config.log_directory .. "/" .. filename .. ".txt")
	file_out:open("w")

	local to_write = ""
	for key, line in next, self.log_history do
		to_write = to_write .. tostring(line) .. "\r\n"
	end

	file_out:write(to_write)

	file_out:close()
end

logging.init = function(self, engine)
	config = engine.config or config

	engine:inherit(self)
	engine:log_write("Start:", engine.start_date)
	engine:log_write("Using engine version " .. tostring(engine.config.version))

	return self
end

logging.close = function(self, engine)
	engine:log_write("End:", engine.end_date)

	if (config.log_recording_enabled) then
		engine:log_record(engine.start_date:gsub("[:/ ]", "."))
	end
end

return logging