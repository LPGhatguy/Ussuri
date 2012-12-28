local console = {}
local engine, lib
console.elapsed_time = 0
console.enabled = false
console.font_name = nil
console.font_size = 14
console.toggle_key = "`"
console.toggle_modifiers = {"lctrl"}
console.captures_updates = true
console.input_box = nil
console.styles = {
	["i"] = {0, 80, 200},
	["o"] = {0, 200, 0},
	["e"] = {200, 0, 0}
}

console.event_priority = {
	keydown = 2,
	mousedown = 0,
	update = 0,
	draw = 952
}

console.event = {
	draw = function(self)
		if (self.enabled) then
			local w, h = love.graphics.getWidth(), love.graphics.getHeight()

			love.graphics.setColor(50, 50, 50, 150)
			love.graphics.rectangle("fill", 8, 8, w - 16, h - 16)

			local default_font = love.graphics.getFont()
			love.graphics.setFont(self.font)

			self.input_box:textbox_draw()

			local at = 0
			for key, piece in next, engine.log_history do
				local style = piece:match("{(.*)}")
				love.graphics.setColor(self.styles[style] or {255, 255, 255})
				love.graphics.print(piece:gsub("{.*}", ""), 8, 40 + (self.font:getHeight() * at))
				at = at + 1
			end
			at = nil

			love.graphics.setFont(default_font)
		end
	end,
	keydown = function(self, event)
		if (event.key == self.toggle_key and love.keyboard.isDown(unpack(self.toggle_modifiers))) then
			self.enabled = not self.enabled
			event.cancel = true
		else
			self.input_box:textbox_keydown(event)
		end
	end,
	update = function(self, event)
		if (self.enabled and self.captures_updates) then
			event.cancel = true
		end
	end,
	mousedown = function(self, event)
		if (self.enabled) then
			event.cancel = true
			self.input_box:textbox_mousedown(event)
		end
	end
}

console.init = function(self, g_engine)
	engine = g_engine
	lib = engine.lib
	self.font = love.graphics.newFont(self.font, self.font_size)

	self.input_box = lib.gui.textbox:new("", self.font)
	self.input_box.x = 12
	self.input_box.y = 12
	self.input_box.width = love.graphics.getWidth() - 14
	self.input_box.height = 20

	self.input_box.text_submit = function(self)
		engine:log_write("{i}", ">" .. self.text)
		local loaded, err = loadstring(self.text)
		local result = false

		if (loaded) then
			result, err = pcall(loaded)
		else
			loaded = loadstring("print(" .. self.text .. ")")
			if (loaded) then
				result, err = pcall(loaded)
			end
		end


		if (not result) then
			local err = err:gsub("^%[.*%]", "")
			engine:log_write("{e}", err)
		end

		self.text = ""
		self.enabled = true
	end

	return self
end

return console