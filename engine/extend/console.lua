local console = {}
console.font_arg = {14}
console.toggle_key = "`"
console.toggle_modifiers = {"lctrl"}
console.enabled = false

console.event_priority = {
	keydown = 2,
	update = 2,
	draw = 951
}

console.event = {
	draw = function(self)
		if (self.enabled) then
			love.graphics.setColor(0, 0, 0, 150)
			love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

			local default_font = love.graphics.getFont()
			love.graphics.setColor(255, 255, 255)
			love.graphics.setFont(self.font)

			love.graphics.printf("CONSOLE ACTIVE (CTRL+` TO CLOSE)", 0, 4, love.graphics.getWidth(), "center")
			--todo: draw everything

			love.graphics.setFont(default_font)
		end
	end,
	keydown = function(self, event)
		if (event.key == self.toggle_key and love.keyboard.isDown(unpack(self.toggle_modifiers))) then
			self.enabled = not self.enabled
			event.cancel = true
		elseif (self.enabled) then
			event.cancel = true
		end
	end,
	update = function(self, event)
		if (self.enabled) then
			event.cancel = true
		end
	end,
}

console.init = function(self, engine)
	self.font = love.graphics.newFont(unpack(self.font_arg))

	return self
end

return console