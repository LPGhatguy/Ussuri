local monitor = {}
monitor.enabled = false
monitor.font_arg = {18}
monitor.toggle_key = "q"
monitor.toggle_modifiers = {"lctrl"}
monitor.features = {
	fps = true,
	total_time = true
}

monitor.event_priority = {
	keydown = 0,
	draw = 951
}

monitor.event = {
	draw = function(self)
		if (self.enabled) then
			local features = self.features
			local out = "DEBUG\n"

			if (features.fps) then
				out = out .. love.timer.getFPS() .. " FPS\n"
			end

			local default_font = love.graphics.getFont()

			love.graphics.setColor(255, 255, 0)
			love.graphics.setFont(self.font)

			love.graphics.print(out, 5, 5)

			love.graphics.setFont(default_font)
		end
	end,
	keydown = function(self, event)
		if (event.key == self.toggle_key and love.keyboard.isDown(unpack(self.toggle_modifiers))) then
			self.enabled = not self.enabled
			event.cancel = true
		end
	end
}

monitor.init = function(self, engine)
	self.font = love.graphics.newFont(unpack(self.font_arg))

	return self
end

return monitor