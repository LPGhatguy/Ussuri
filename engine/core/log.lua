local log = {}
log.log_history = {}
log.log_directory = "logs"

log.log_write = function(self, contents)
	table.insert(self.log_history, contents)
end

log.log_record = function(self, filename)
	if (not love.filesystem.exists(self.log_directory)) then
		love.filesystem.mkdir(self.log_directory)
	end

	local file_out = love.filesystem.newFile(self.log_directory .. "/" .. filename .. ".txt")
	file_out:open("w")

	local to_write = ""
	for key, line in next, self.log_history do
		to_write = to_write .. tostring(line) .. "\r\n"
	end

	file_out:write(to_write)

	file_out:close()
end

log.init = function(self, engine)
	engine:inherit(self)

	return self
end

return log