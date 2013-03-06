--[[
Debug Monitor
Used for quick or custom debug information
]]

local monitor

monitor = {
	enabled = false,
	numeric_accuracy = 3,
	toggle_key = "q",
	font_arg = {18},
	toggle_modifiers = {"lctrl"},
	disabled = {},
	lookups = {},

	values = {
		fps = 0,
		time = 0
	},

	event_priority = {
		update = 0,
		keydown = 0,
		draw = 951
	},

	event = {
		draw = function(self)
			if (self.enabled) then
				local out = "DEBUG\n"

				for key, value in next, self.values do
					out = out .. key:upper() .. ": " .. self:draw_value(value) .. "\n"
				end

				for key, value in next, self.lookups do
					out = out .. key:upper() .. ": " .. self:draw_value(value[1][value[2]]) .. "\n"
				end

				love.graphics.setColor(255, 255, 0)
				love.graphics.setFont(self.font)

				love.graphics.print(out, 5, 5)
			end
		end,
		update = function(self, event)
			self.values.fps = love.timer.getFPS()
			self.values.time = self.values.time + event.delta
		end,
		keydown = function(self, event)
			if (event.key == self.toggle_key and love.keyboard.isDown(unpack(self.toggle_modifiers))) then
				self.enabled = not self.enabled
				event.cancel = true
			end
		end
	},

	draw_value = function(self, value)
		if (type(value) == "number") then
			return tostring(value):match("%d*%.?" .. ("%d?"):rep(self.numeric_accuracy))
		else
			return tostring(value)
		end
	end,

	init = function(self, engine)
		self.font = love.graphics.newFont(unpack(self.font_arg))
	end
}

return monitor