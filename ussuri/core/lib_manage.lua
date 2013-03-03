--[[
Library Manager
Manages the loading and keying of libraries
]]

local lib, engine_path
local lib_manage

local lib_meta = {
	__key = function(self, ...)
		return self:lib_get(...)
	end
}

lib_manage = {
	libraries = {},

	lib_get = function(self, path, name)
		local out = rawget(lib, path)

		if (out) then
			return out
		else
			return self:lib_load(path, name)
		end
	end,

	lib_batch_get = function(self, libs)
		for key, library in next, libs do
			if (type(library) == "table") then
				self:lib_get(unpack(library))
			else
				self:lib_get(library)
			end
		end
	end,

	lib_batch_load = function(self, libs)
		for key, library in next, libs do
			if (type(library) == "table") then
				self:lib_load(unpack(library))
			else
				self:lib_load(library)
			end
		end
	end,

	lib_folder_load = function(self, folder, order)
		local loaded = {}
		local path = folder:gsub("^:", engine_path)
		local fixed_path = path:gsub("%.", "/")

		if (love.filesystem.exists(fixed_path .. "/init.lua")) then
			self:lib_get(folder .. ".init")
		end

		if (order) then
			for key, library in next, order do
				if (type(library) == "table") then
					self:lib_get(folder .. "." .. library[1], library[2])
				else
					self:lib_get(folder .. "." .. library)
				end

				loaded[library] = true
			end
		end

		for key, library in next, love.filesystem.enumerate(fixed_path) do
			local library_name = library:match("(.-)%..-$")
			local library_path = folder .. "." .. library_name
			
			if (not loaded[library_name]) then
				self:lib_get(library_path)
			end
		end
	end,

	lib_load = function(self, path, name)
		local name = name or path
		local path = path:gsub("^:", engine_path)

		local result, loaded = pcall(require, path)

		if (result) then
			if (type(loaded) == "table" and loaded.init) then
				loaded:init(self)

				table.insert(self.libraries, loaded)
			elseif (type(loaded) == "function") then
				loaded(self)
			end

			if (loaded) then
				if (string.match(name, "[%.]")) then
					local name = name:gsub(":", "")
					local lib_name = name:match("([^%.:]*)$")
					local store_in = lib

					for addition in string.gmatch(name, "([^%.]+)%.") do
						if (not store_in[addition]) then
							store_in[addition] = {}
						end

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
			end

			return lib
		else
			error(loaded)
		end
	end,

	init = function(self, engine)
		lib = engine.lib or lib
		engine_path = engine.config.engine_path or engine_path

		engine:inherit(self)
	end,

	close = function(self, engine)
		for key, library in next, self.libraries do
			if (library.close) then
				library:close(engine)
			end
		end
	end
}

setmetatable(lib_manage.libraries, {__mode = "v"})

return lib_manage