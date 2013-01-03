local sound = {}
sound.playing_music = {}
sound.playing_effects = {}
sound.loaded = {}
sound.collection_time = 2
sound.elapsed = 0

sound.event_priority = {
	update = 0
}

sound.event = {
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
}

sound.load_music = function(self, filename, name)
	local name = name or (filename):match("([^%./]+)%..+$")
	local decoder = love.sound.newDecoder(filename)
	self.loaded[name] = decoder

	return decoder
end

sound.load_effect = function(self, filename, name)
	local name = name or (filename):match("([^%./]+)%..+$")
	local data = love.sound.newSoundData(filename)
	self.loaded[name] = data

	return data
end

sound.play_music = function(self, name, looping)
	local found = self.loaded[name]
	if (found) then
		local source = love.audio.newSource(found, "stream")
		source:setLooping(looping)
		source:play()

		table.insert(self.playing_music, source)
		return source
	end
end

sound.play_effect = function(self, name, looping)
	local found = self.loaded[name]
	if (found) then
		local source = love.audio.newSource(found)
		source:setLooping(looping)
		source:play()

		table.insert(self.playing_effects, source)
		return source
	end
end

sound.pause_music = function(self, name)
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
end

sound.resume_music = function(self, name)
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
end

sound.toggle_play_music = function(self, name)
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
end

sound.stop = function(self, name)
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
end

sound.init = function(self, engine)
	engine.lib.oop:objectify(self)

	return self
end

return sound