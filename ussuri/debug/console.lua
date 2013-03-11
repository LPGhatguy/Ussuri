--[[
Console
Enables execution of Lua code in-game. Useful for debugging.
Depends on ui
]]

local engine, lib
local console

console = {
	background_color = {0, 0, 0, 200},
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
		keydown = -501,
		mousedown = -501,
		update = -501,
		draw = 501
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
				self:trigger_event("keydown", event)
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
		end,

		display_updated = function(self, event)
			self.width = event.width - 16
			self.height = event.height - 16

			self.output_box.width = self.width - 8
			self.output_box.height = self.height - 38

			self.input_box.width = self.width - 8
		end
	},

	init = function(self, g_engine)
		engine = g_engine
		lib = engine.lib

		self.font = love.graphics.newFont(14)
		self.width = love.graphics.getWidth() - 16
		self.height = love.graphics.getHeight() - 16

		lib.utility.table_copy(getfenv(0), self.environment)

		self.environment.ussuri = engine
		self.environment.print = function(...)
			engine:log_writes("green", ...)
		end

		lib.oop:objectify(self)
		self:inherit(lib.ui.frame, "frame")

		local output_box = lib.ui.styled_textlabel:new()
		self.output_box = output_box
		output_box.x = 4
		output_box.y = 32
		output_box.width = self.width - 8
		output_box.height = self.height - 38
		output_box.background_color = {100, 100, 100, 100}
		output_box.font = self.font
		output_box:refurbish(table.concat(engine.log_history, "\n"))
		self:add(output_box)

		local codebox = {
			history = {},
			history_location = 0,

			keydown = function(self, event)
				local key = event.key

				if (key == "up" or key == "down") then
					local translation = (key == "down") and 1 or -1

					self.history_location = math.min(math.max(self.history_location + translation, 1), #self.history)
					self.text = self.history[self.history_location] or self.text
					self:set_cursor(math.huge)
				else
					self._textbox.keydown(self, event)

					if (key ~= "left" and key ~= "right") then
						self.history_location = #self.history + 1
					end
				end
			end
		}

		lib.oop:objectify(codebox)

		codebox:inherit(lib.ui.textbox, "textbox")
		codebox.new = lib.ui.textbox.new

		local input_box = codebox:new("", self.font)
		self.input_box = input_box
		input_box.x = 4
		input_box.y = 4
		input_box.width = self.width - 8
		input_box.height = 16
		input_box.background_color = self.output_box.background_color
		self:add(input_box)

		input_box.event_text_submit:connect(function(box)
			if (box.text:len() > 0) then
				engine:log_writes("blue", ">", box.text)
				table.insert(box.history, box.text)

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

				if (not result and err) then
					local err = err:gsub("^%[.*%]", "")
					engine:log_writes("red", err)
				end

				box.text = ""
			end

			box.enabled = true
		end)

		engine.event_log:connect(function()
			self.output_box:refurbish(table.concat(engine.log_history, "\n"))
		end)
	end
}

return console