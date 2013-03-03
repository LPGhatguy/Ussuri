--[[
Plain Text Label
Draws text
Inherits ui.base, ui.rectangle
]]

local lib
local textlabel

textlabel = {
	text = "",
	text_color = {255, 255, 255},
	border_width = 0,

	draw = function(self)
		self._rectangle.draw(self)

		love.graphics.setFont(self.font)
		love.graphics.setColor(self.text_color)
		love.graphics.print(self.text, self.x, self.y)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		self:inherit(lib.ui.base)
		self:inherit(lib.ui.rectangle, "rectangle")
	end,
}

return textlabel