--[[
Console
Enables execution of Lua code in-game. Useful for debugging
Written by Lucien Greathouse
]]

local console = {}
local engine, lib

console.elapsed_time = 0
console.enabled = false
console.log_input = true
console.font_name = nil
console.font_size = 14
console.toggle_key = "`"
console.toggle_modifiers = {"lctrl"}
console.captures_updates = true
console.input_box = nil

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

			love.graphics.setColor(0, 0, 0, 200)
			love.graphics.rectangle("fill", 8, 8, w - 16, h - 16)

			local default_font = love.graphics.getFont()
			love.graphics.setFont(self.font)

			self.input_box:textbox_draw()

			lib.gui:prints(table.concat(engine.log_history, "\n"), 8, 40)

			if (default_font) then
				love.graphics.setFont(default_font)
			end
		end
	end,
	keydown = function(self, event)
		if (event.key == self.toggle_key and love.keyboard.isDown(unpack(self.toggle_modifiers))) then
			self.enabled = not self.enabled
			event.cancel = true
		elseif (self.enabled) then
			self.input_box:textbox_keydown(event)
			event.cancel = true
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
	self.input_box.width = love.graphics.getWidth() - 24
	self.input_box.height = 16
	self.input_box.background_color = {100, 100, 100, 100}

	self.input_box.text_submit = self.input_box.text_submit + function(box)
		if (self.log_input) then
			engine:log_writes("blue", box.text)
		end

		local loaded, err = loadstring(box.text)
		local result = false

		if (loaded) then
			result, err = pcall(loaded)
		else
			--This is the half-decent way to handle this...
			loaded = loadstring("return _+(" .. box.text .. ")")
			if (loaded) then
				result, err = pcall(loaded)
			end
		end

		if (not result) then
			local err = err:gsub("^%[.*%]", "")
			engine:log_writes("red", err)
		end

		box.text = ""
		box.enabled = true
	end

	return self
end

return console