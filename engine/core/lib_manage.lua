local lib_manage = {}
local lib, engine_path

lib_manage.lib_get = function(self, path, name)
	if (lib[path]) then
		return lib[path]
	else
		return self:lib_load(path, name)
	end
end

lib_manage.lib_batch_get = function(self, libs)
	for key, library in next, libs do
		if (type(library) == "table") then
			local path, name = unpack(library)
			self:lib_get(path, name)
		else
			self:lib_get(library)
		end
	end
end

lib_manage.lib_load = function(self, path, name)
	local name = name or path
	local path = path:gsub("^:", engine_path)

	local loaded = require(path)
	if (loaded and loaded.init) then
		loaded = loaded:init(self)
	end

	lib[name] = loaded

	return lib
end

lib_manage.lib_batch_load = function(self, libs)
	for key, library in next, libs do
		if (type(library) == "table") then
			self:load_lib(unpack(library))
		else
			self:load_lib(library)
		end
	end
end

lib_manage.init = function(self, engine)
	lib = engine.lib or lib
	engine_path = engine.engine_path or engine_path

	engine:inherit(self)

	return self
end

return lib_manage