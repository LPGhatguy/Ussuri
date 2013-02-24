--[[
UI Utility Library
Provides various UI utility methods
]]

local lib
local ui

ui = {
	colors = {
		["white"] = {255, 255, 255},
		["black"] = {0, 0, 0},
		["red"] = {200, 0, 0},
		["pink"] = {200, 0, 200},
		["yellow"] = {200, 200, 0},
		["blue"] = {0, 80, 200},
		["green"] = {0, 200, 80}
	},

	point_in_item = function(item, x, y)
		local item_x, item_y = item.x, item.y

		return (x > item_x and x < item_x + item.width) and
			(y > item_y and y < item_y + item.height)
	end,

	color_add = function(self, name, color)
		if (not self.colors[name]) then
			self.colors[name] = color
		end
	end,

	color_decompose = function(self, text)
		local out_text = {}
		local out_color = {}

		local uncolored = string.match(text, "^[^\b]+")
		if (uncolored) then
			out_text[1] = string.match(text, "^[^\b]+")
			out_color[1] = "white"
		end

		for color_piece, text_piece in string.gmatch(text, "\b(.-)\b([^\b]*)") do
			table.insert(out_text, text_piece)
			table.insert(out_color, color_piece)
		end

		return out_text, out_color
	end,

	prints = function(self, text, x, y)
		local text, color = self:color_decompose(text)
		local font = love.graphics.getFont()

		local atx, aty = x, y
		for id, piece in next, text do
			love.graphics.setColor(self.colors[color[id]])
			love.graphics.print(piece, atx, aty)

			local _, newlines = piece:gsub("\n", "")

			atx = atx + font:getWidth(piece)

			if (newlines > 0) then
				aty = aty + font:getHeight() * newlines
				atx = x
			end
		end
	end,

	init = function(self, engine)
		lib = engine.lib

		return self
	end
}

return ui