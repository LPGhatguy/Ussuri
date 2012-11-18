local engine_core = {}
local lib, config = {}, {}
local engine_path = debug.getinfo(1).short_src:match("([^%.]*)[\\/][^%.]*%..*$"):gsub("[\\/]", ".") .. "."
config.engine_path = engine_path

local function load_lib(load)
	local name = load:gsub("^:", "")
	local loaded = require(load:gsub("^:", config.engine_path)):init(engine_core)
	lib[name] = loaded

	return loaded
end

local function batch_load_lib(batch)
	for index, lib_name in next, batch do
		load_lib(lib_name)
	end
end

engine_core.init = function(self, glib)
	lib = glib or lib
	engine_core.lib = lib

	config = require(engine_path .. "config")
	config.engine_path = config.engine_path or engine_path
	engine_core.config = config

	batch_load_lib(config.core_lib)

	return self
end

return engine_core