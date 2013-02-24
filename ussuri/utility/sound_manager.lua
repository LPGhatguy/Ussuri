--[[
Lightweight Sound Manager
Temporary for light use; will be replaced later
]]

local sound

sound = {
	playing_music = {},
	playing_effects = {},
	loaded = {},
	collection_time = 2,
	elapsed = 0,

	event_priority = {
		update = 0
	},

	event = {
		update = function(self, event)
			local elapsed = self.elapsed
			self.elapsed = elapsed + event.delta

			if (elapsed > self.collection_time) then
				self.elapsed = elapsed - self.collection_time

				for key, sound in next, self.playing_music do
					if (sound:isStopped()) then
						self.playing_music[key] = nil
					end
				end

				for key, sound in next, self.playing_effects do
					if (sound:isStopped()) then
						self.playing_effects[key] = nil
					end
				end
			end
		end
	},

	load_music = function(self, filename, name)
		local name = name or (filename):match("([^%./]+)%..+$")
		local decoder = love.sound.newDecoder(filename)
		self.loaded[name] = decoder

		return decoder
	end,

	load_effect = function(self, filename, name)
		local name = name or (filename):match("([^%./]+)%..+$")
		local data = love.sound.newSoundData(filename)
		self.loaded[name] = data

		return data
	end,

	play_music = function(self, name, looping)
		local found = self.loaded[name]
		if (found) then
			local source = love.audio.newSource(found, "stream")
			source:setLooping(looping)
			source:play()

			table.insert(self.playing_music, source)
			return source
		end
	end,

	play_effect = function(self, name, looping)
		local found = self.loaded[name]
		if (found) then
			local source = love.audio.newSource(found)
			source:setLooping(looping)
			source:play()

			table.insert(self.playing_effects, source)
			return source
		end
	end,

	pause_music = function(self, name)
		if (name) then
			local playing = self.playing_music[name]
			if (playing) then
				playing:pause()
			end
		else
			for key, value in next, self.playing_music do
				value:pause()
			end
		end
	end,

	resume_music = function(self, name)
		if (name) then
			local playing = self.playing_music[name]
			if (playing) then
				playing:resume()
			end
		else
			for key, value in next, self.playing_music do
				value:resume()
			end
		end
	end,

	toggle_play_music = function(self, name)
		if (name) then
			local playing = self.playing_music[name]
			if (playing) then
				if (playing:isPaused()) then
					playing:resume()
				else
					playing:pause()
				end
			end
		else
			for key, value in next, self.playing_music do
				if (value:isPaused()) then
					value:resume()
				else
					value:pause()
				end
			end
		end
	end,

	stop = function(self, name)
		if (name) then
			local playing = self.playing_music[name]
			if (playing) then
				playing:stop()
			end
		else
			for key, value in next, self.playing_music do
				value:stop()
			end
		end
	end,

	toggle_sound = function(self)
		local current_volume = love.audio.getVolume()
		if (current_volume == 0) then
			love.audio.setVolume(self.old_volume or 1)
		else
			self.old_volume = current_volume
			love.audio.setVolume(0)
		end
	end,

	enable_sound = function(self)
		love.audio.setVolume(self.old_volume or 1)
	end,

	disable_sound = function(self)
		self.old_volume = love.audio.getVolume()
		love.audio.setVolume(0)
	end,

	init = function(self, engine)
		engine.lib.oop:objectify(self)
	end
}

return sound