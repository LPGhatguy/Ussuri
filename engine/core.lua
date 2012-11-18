local engine_core = {}
local lib, config = {}, {}
local engine_path = debug.getinfo(1).short_src:match("([^%.]*)[\\/][^%.]*%..*$"):gsub("[\\/]", ".") .. "."
config.engine_path = engine_path

engine_core.start_date = os.date()

local function lib_load(load)
	local name = load:match("([^%.:]*)$")
	local loaded = require(load:gsub("^:", config.engine_path)):init(engine_core)
	lib[name] = loaded

	return loaded
end

local function lib_batch_load(batch)
	for index, lib_name in next, batch do
		lib_load(lib_name)
	end
end

engine_core.init = function(self, glib)
	lib = glib or lib
	engine_core.lib = lib

	config = require(engine_path .. "config")
	config.engine_path = config.engine_path or engine_path
	engine_core.config = config

	lib_batch_load(config.core_lib)
	self:lib_batch_get(config.engine_lib)

	self:log_write("Start: " .. self.start_date)

	return self
end

engine_core.close = function(self)
	if (config.record_logs) then
		self:log_write("End: " .. os.date())
		self:log_record(self.start_date:gsub("[/: ]", "."))
	end
end

return engine_core