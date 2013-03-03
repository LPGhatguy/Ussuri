local lib, config, corelib = {}, {}, {}
local engine_core = {}

local engine_path = debug.getinfo(1).short_src:match("([^%.]*)[\\/][^%.]*%..*$"):gsub("[\\/]", ".") .. "."
config.engine_path = engine_path

engine_core.start_date = os.date()

local version_meta = {
	__tostring = function(self)
		return table.concat(self, ".")
	end
}

local function lib_load(load)
	local name = load:match("([^%.:]*)$")
	local loaded = require(load:gsub("^:", config.engine_path))
	loaded:init(engine_core)
	loaded.init = nil
	lib[name] = loaded
	corelib[name] = loaded

	return loaded
end

local function lib_batch_load(batch)
	for key, lib_name in next, batch do
		lib_load(lib_name)
	end
end

engine_core.init = function(self, glib)
	lib = glib or lib
	self.lib = lib

	config = require(engine_path .. "config")
	config.engine_path = config.engine_path or engine_path
	self.config = config

	setmetatable(config.version, version_meta)

	lib_batch_load(config.lib_core)

	for at, group in next, config.lib_folders do
		self:lib_folder_load(group[1], group[2])
	end

	return self
end

engine_core.close = function(self)
	self.end_date = os.date()

	for key, library in pairs(corelib) do
		if (library.close) then
			library:close(self)
		end
		lib[key] = nil
	end
end

engine_core.quit = function(self)
	self:close()
	love.event.push("quit")
end

return engine_core