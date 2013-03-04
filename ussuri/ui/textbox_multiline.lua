--[[
Multiple Line Textbox
A textbox with more than one line
Inherits input.text_multiline
]]

local lib
local textbox

textbox = {
	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.input.text_multiline)
	end,
}

return textbox