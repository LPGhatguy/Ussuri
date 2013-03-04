--[[
Console
Enables execution of Lua code in-game. Useful for debugging.
Depends on ui
]]

local engine, lib
local console

console = {
	x = 8,
	y = 8,
	border_width = 1,
	elapsed_time = 0,
	enabled = false,
	toggle_key = "`",
	toggle_modifiers = {"lctrl"},
	captures_updates = true,
	environment = {},

	event_priority = {
		keydown = 2,
		mousedown = 0,
		update = 0,
		draw = 952
	},

	event = {
		draw = function(self, event)
			if (self.enabled) then
				self._frame.draw(self, event)
			end
		end,

		keydown = function(self, event)
			if (event.key == self.toggle_key and love.keyboard.isDown(unpack(self.toggle_modifiers))) then
				self.enabled = not self.enabled
				event.cancel = true
			elseif (self.enabled) then
				self.input_box:keydown(event)
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
				self._ui_container.mousedown(self, event)
			end
		end
	},

	init = function(self, g_engine)
		engine = g_engine
		lib = engine.lib

		self.font = love.graphics.newFont(14)

		lib.utility.table_copy(getfenv(0), self.environment)

		self.environment.ussuri = engine
		self.environment.print = function(...)
			engine:log_writes("green", ...)
		end

		lib.oop:objectify(self)
		self:inherit(lib.ui.frame, "frame")

		self.width = love.graphics.getWidth() - 16
		self.height = love.graphics.getHeight() - 16
		self.background_color = {0, 0, 0, 200}

		self.output_box = lib.ui.styled_textlabel:new()
		self.output_box.x = 4
		self.output_box.y = 32
		self.output_box.width = love.graphics.getWidth() - 24
		self.output_box.height = love.graphics.getHeight() - 52
		self.output_box.background_color = {100, 100, 100, 100}
		self.output_box.font = self.font
		self.output_box:refurbish(table.concat(engine.log_history, "\n"))
		self:add(self.output_box)

		self.input_box = lib.ui.textbox:new("", self.font)
		self.input_box.x = 4
		self.input_box.y = 4
		self.input_box.width = love.graphics.getWidth() - 24
		self.input_box.height = 16
		self.input_box.background_color = self.output_box.background_color
		self:add(self.input_box)

		self.input_box.event_text_submit:connect(function(box)
			engine:log_writes("blue", ">", box.text)

			local loaded, err = loadstring(box.text)
			local result = false

			if (loaded) then
				setfenv(loaded, self.environment)
				result, err = pcall(loaded)
			else
				loaded = loadstring("print(" .. box.text .. ")")
				if (loaded) then
					setfenv(loaded, self.environment)
					result, err = pcall(loaded)
				end
			end

			if (not result) then
				local err = err:gsub("^%[.*%]", "")
				engine:log_writes("red", err)
			end

			box.text = ""
			box.enabled = true
		end)

		engine.event_log:connect(function()
			self.output_box:refurbish(table.concat(engine.log_history, "\n"))
		end)
	end
}

return console