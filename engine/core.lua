local engine_core = {}
local lib, config = {}, {}
local engine_path = debug.getinfo(1).short_src:match("([^%.]*)[\\/][^%.]*%..*$"):gsub("[\\/]", ".") .. "."

engine_core.config_get = function(key)
	return config[key]
end

engine_core.config_set = function(key, value)
	config[key] = value
end

engine_core.init = function(self, glib)
	lib = glib

	config = require(engine_path .. "config")
	config.engine_path = config.engine_path or engine_path

	return self
end

return engine_core