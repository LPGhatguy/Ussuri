--[[
Resource Manager (Work in Progress!)
Loads and unloads resources on demand
]]

local lib
local resource

resource = {
	loaded = {},
	extensions = {
		["image"] = love.graphics.newImage,
		["imagedata"] = love.image.newImageData,
		["soundstream"] = love.sound.newDecoder,
		["soundeffect"] = love.sound.newSoundData,
		["font"] = love.graphics.newFont
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

	fetch = function(self, filepath, as)
		local path, name, extension = filepath:match("(.-)/?([^/]-)%.(.-)$")
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