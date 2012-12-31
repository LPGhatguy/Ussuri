local gui = {}
local print = print
local lib = {}
gui.styles = {
	["default"] = {255, 255, 255},
	["red"] = {200, 0, 0},
	["blue"] = {0, 200, 0},
	["green"] = {0, 80, 200},
	["in"] = {0, 80, 200},
	["out"] = {0, 200, 0},
	["err"] = {200, 0, 0}
}

gui.style_decompose = function(self, text)
	local out_text = {}
	local out_style = {}

	local unstyled = string.match(text, "^[^\b]+")
	if (unstyled) then
		out_text[1] = string.match(text, "^[^\b]+")
		out_style[1] = "default"
	end

	for style_piece, text_piece in string.gmatch(text, "\b(.-)\b([^\b]*)") do
		table.insert(out_text, text_piece)
		table.insert(out_style, style_piece)
	end

	return out_text, out_style
end

gui.prints = function(self, text, x, y)
	local text, style = self:style_decompose(text)
	local font = love.graphics.getFont()

	local atx, aty = x, y
	for id, piece in next, text do
		love.graphics.setColor(self.styles[style[id]])
		love.graphics.print(piece, atx, aty)

		local _, newlines = piece:gsub("\n", "")

		atx = atx + font:getWidth(piece)

		if (newlines > 0) then
			aty = aty + font:getHeight() * newlines
			atx = x
		end
	end
end

gui.init = function(self, engine)
	lib = engine.lib

	return self
end

return gui