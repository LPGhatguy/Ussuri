--color.lua
--contains code adapted from the LÖVE wiki (love2d.org/wiki)
local color = {}

color.hsv = function(h, s, v, a)
	if (s <= 0) then
		return v, v, v, a
	end

	h, s, v = (h * 6) / 256, s / 255, v / 255
	local c = v * s
	local x = (1 - math.abs((h % 2) - 1)) * c
	local m = (v - c)
	local r, g, b

	if (h < 1) then
		r, g, b = c, x, 0
	elseif (h < 2) then
		r, g, b = x, c, 0
	elseif (h < 3) then
		r, g, b = 0, c, x
	elseif (h < 4) then
		r, g, b = 0, x, c
	elseif (h < 5) then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return (r + m) * 255, (g + m) * 255, (b + m) * 255, a
end

color.hsl = function(h, s, l, a)
    if (s <= 0) then
    	return l, l, l, a
    end

	h, s, l = (h * 6) / 256, s / 255, l / 255
	local c = (1 - math.abs(2 * l - 1)) * s
	local x = (1 - math.abs((h % 2) - 1)) * c
	local m = (l - .5 * c)
	local r, g, b

	if (h < 1) then
		r, g, b = c, x, 0
	elseif (h < 2) then
		r, g, b = x, c, 0
	elseif (h < 3) then
		r, g, b = 0, c, x
	elseif (h < 4) then
		r, g, b = 0, x, c
	elseif (h < 5) then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return (r + m) * 255, (g + m) * 255, (b + m) * 255, a
end

return color