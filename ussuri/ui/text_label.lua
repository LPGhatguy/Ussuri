--[[
Text Label
Displays text in a rectangle
]]

local lib
local rectangle
local text_label

text_label = {
	text_color = {255, 255, 255},

	text = "",
	auto_y = false,
	auto_x = false,

	draw = function(self, event)
		rectangle.draw(self, event)

		love.graphics.setColor(self.text_color)
		love.graphics.print(self.text, self.x, self.y)
	end,

	_new = function(base, new, text, x, y, w, h)
		new.text = text

		rectangle._new(base, new, x, y, w, h)

		return new
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		rectangle = self:inherit(engine:lib_get(":ui.rectangle"))
	end
}

return text_label