--[[
Resource Manager (Work in Progress)
Loads and unloads resources on demand
]]

local lib
local resource

resource = {
	loaded = {},
	file_cache = {},
	extensions = {
		["image"] = {love.graphics.newImage},
		["imagedata"] = {love.image.newImageData},
		["soundstream"] = {love.sound.newDecoder},
		["soundeffect"] = {love.sound.newSoundData},
		["font"] = {love.graphics.newFont}
	},
	types = {
		["gif"] = "image",
		["png"] = "image",
		["jpg"] = "image",
		["bmp"] = "image",
		["mp3"] = "soundstream",
		["wav"] = "soundeffect",
		["ttf"] = "font"
	},

	fetch = function(self, file_path, file_type)
		local preloaded = self.file_cache[file_path]

		if (preloaded) then
			return preloaded
		else
			local path, name, extension = file_path:match("(.-)/?([^/]-)%.(.-)$")
			local file_class = self.types[file_type] or self.types[extension]

			if (file_class) then
				local loader = self.extensions[file_class]

				if (loader) then
					local asset = lib.utility.table_pop(loader)(file_path, unpack(loader))

					if (asset) then
						self.file_cache[file_path] = asset
						self.loaded[as] = asset
						return asset
					end
				end
			end
		end
	end,

	load = function(self)
	end,

	unload = function(self)
	end,

	add_directory = function(self, name, directory)
		self.loaded[name] = {directory}
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		return self
	end
}

return resource