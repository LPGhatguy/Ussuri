--[[
One Line Textbox
Implements text rendering with inherited textbox input.
Inherits ui.base, input.text
]]

local lib
local textbox

textbox = {
	auto_size = false,
	selection_color = {0, 80, 200},
	cursor_color = {255, 255, 255},
	text_color = {255, 255, 255},
	cursor_width = 1,
	border_width = 0,

	keydown = function(self, event)
		if (self.enabled) then
			event.cancel = true
		end
		self._text.keydown(self, event)
	end,

	mousedown = function(self, event)
		self.enabled = ((event.x > self.x and event.x < self.x + self.width) and
			(event.y > self.y and event.y < self.y + self.height))
	end,

	draw = function(self)
		local auto_size = self.auto_size
		local x, y = self.x, self.y
		local width = auto_size and self.font:getWidth(self.text) or self.width
		local height = auto_size and self.font:getHeight() or self.height

		self._rectangle.draw(self)

		love.graphics.setScissor(x, y, math.max(width, 1), height)

		local cursor_x = x + self.font:getWidth(self.text:sub(1, self.cursor))

		if (self.enabled) then
			if (self.cursor ~= self.selection) then
				local min, max = math.min(self.cursor, self.selection), math.max(self.cursor, self.selection)

				width = self.font:getWidth(self.text:sub(min + 1, max)) * (max == self.cursor and -1 or 1)

				love.graphics.setColor(self.selection_color)
				love.graphics.rectangle("fill", cursor_x, y, width, self.font:getHeight())
			end

			love.graphics.setColor(self.cursor_color)
			love.graphics.setLineWidth(self.cursor_width)
			love.graphics.line(cursor_x, x, cursor_x, y + self.font:getHeight())
		end

		love.graphics.setColor(self.text_color)
		love.graphics.print(self.text, x, y)

		love.graphics.setScissor()
	end,

	new = function(self, text, font)
		local instance = self.base.new(self)
		instance = self._text.new(instance, text)

		instance.font = font or instance.font

		return instance
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		self:inherit(lib.ui.base, true)
		self:inherit(lib.ui.rectangle, "rectangle")
		self:inherit(lib.input.text, "text")
	end
}

textbox.event = {
	keydown = textbox.keydown,
	draw = textbox.draw,
	mousedown = textbox.mousedown
}

return textbox