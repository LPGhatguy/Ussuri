--[[
Basic Textbox
Implements basic text rendering and input
Written by Lucien Greathouse
]]

local textbox = {}
local lib
textbox.x = 0
textbox.y = 0
textbox.width = auto
textbox.height = auto
textbox.selection_color = {0, 80, 200}
textbox.cursor_color = {255, 255, 255}
textbox.text_color = {255, 255, 255}
textbox.background_color = {100, 100, 100}

textbox.textbox_keydown = function(self, event)
	if (self.enabled) then
		event.cancel = true
	end
	self:text_keydown(event)
end

textbox.textbox_mousedown = function(self, event)
	self.enabled = ((event.x > self.x and event.x < self.x + self.width) and
		(event.y > self.y and event.y < self.y + self.height))
end

textbox.textbox_draw = function(self)
	local x, y = self.x, self.y
	local width = self.width or self.font:getWidth(self.text)
	local height = self.height or self.font:getHeight()

	love.graphics.setScissor(x, y, math.max(width, 1), height)

	love.graphics.setColor(self.background_color)
	love.graphics.rectangle("fill", x, y, math.max(width, 1), height)

	local cursor_x = x + self.font:getWidth(self.text:sub(1, self.cursor))

	if (self.enabled) then
		if (self.cursor ~= self.selection) then
			local min, max = math.min(self.cursor, self.selection), math.max(self.cursor, self.selection)

			width = self.font:getWidth(self.text:sub(min + 1, max)) * (max == self.cursor and -1 or 1)

			love.graphics.setColor(self.selection_color)
			love.graphics.rectangle("fill", cursor_x, y, width, self.font:getHeight())
		end

		love.graphics.setColor(self.cursor_color)
		love.graphics.line(cursor_x, x, cursor_x, y + self.font:getHeight())
	end

	love.graphics.setColor(self.text_color)
	love.graphics.print(self.text, x, y)

	love.graphics.setScissor()
end

textbox.event = {
	keydown = textbox.textbox_keydown,
	draw = textbox.textbox_draw,
	mousedown = textbox.textbox_mousedown
}

textbox.new = function(self, text, font)
	local new = self:_new()

	new.text = text or new.text
	new.font = font or new.font

	return new
end

textbox.init = function(self, engine)
	lib = engine.lib

	lib.oop:objectify(self)
	self:inherit(lib.input.text)

	return self
end

return textbox