--[[
Library Manager
Manages the loading and indexing of libraries
Written by Lucien Greathouse
]]

local lib_manage = {}
local lib, engine_path

local lib_meta = {
	__index = function(self, ...)
		return self:lib_get(...)
	end
}

lib_manage.lib_get = function(self, path, name)
	if (rawget(lib, path)) then
		return rawget(lib, path)
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

lib_manage.lib_folder_load = function(self, folder, order)
	local loaded = {}
	local path = folder:gsub("^:", engine_path)

	if (order) then
		for id, library in next, order do
			if (type(library) == "table") then
				self:lib_get(folder .. "." .. library[1], library[2])
			else
				self:lib_get(folder .. "." .. library)
			end

			loaded[library] = true
		end
	end

	local fixed_path = path:gsub("%.", "/")
	local files = love.filesystem.enumerate(fixed_path)

	for id, library in next, files do
		local library_name = library:gsub("%..*$", "")
		local library_path = folder .. "." .. library_name
		
		if (not loaded[library_name]) then
			self:lib_get(library_path)
		end
	end
end

lib_manage.lib_load = function(self, path, name)
	local name = name or path
	local path = path:gsub("^:", engine_path)

	local loaded = require(path)
	if (type(loaded) == "table" and loaded.init) then
		loaded = loaded:init(self) or loaded
		loaded.init = nil
	end

	if (string.match(name, "[%.]")) then
		local name = name:gsub(":", "")
		local lib_name = name:match("([^%.:]*)$")
		local store_in = lib
		local store_old = store_in

		for addition in string.gmatch(name, "([^%.]+)%.") do
			if (not store_in[addition]) then
				store_in[addition] = {}
			end

			store_old = store_in
			store_in = store_in[addition]
		end

		if (lib_name == "init") then
			lib.utility.table_merge(loaded, store_in)
			loaded = store_in
		else
			store_in[lib_name] = loaded
		end
	else
		lib[name] = loaded
	end

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
	engine_path = engine.config.engine_path or engine_path

	engine:inherit(self)

	return self
end

return lib_manage