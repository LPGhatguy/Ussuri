--[[
Resource Manager (Work in Progress)
Loads and unloads resources on demand
]]

local lib
local resource

resource = {
	base_directory = "",
	assets = {},
	structure = {},
	file_cache = {},
	extensions = {
		["image"] = {love.graphics.newImage, {}},
		["imagedata"] = {love.image.newImageData, {}},
		["soundstream"] = {love.sound.newDecoder, {}},
		["soundeffect"] = {love.sound.newSoundData, {}},
		["font"] = {love.graphics.newFont, {}}
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

	get_file_type = function(self, file_path)
		return self.types[file_path:match("%.(.-)$")]
	end,

	fetch = function(self, file_path, file_type)
		local preloaded = self.file_cache[file_path]

		if (preloaded) then
			return preloaded
		else
			local file_class = self.types[file_type] or self:get_file_type(file_path)

			if (file_class) then
				local loader = self.extensions[file_class]

				if (loader) then
					local asset = loader[1](file_path, unpack(loader[2]))

					if (asset) then
						self.file_cache[file_path] = asset
						return asset
					end
				end
			end
		end
	end,

	load = function(self, name)
		local asset = self.assets[name]

		if (asset) then
			return asset
		end
	end,

	unload = function(self)
	end,

	directory = function(self, path, ...)
		return {path = path, ...}
	end,

	file = function(self, name)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
	end
}

setmetatable(resource.file_cache, {__mode = "v"})

return resource