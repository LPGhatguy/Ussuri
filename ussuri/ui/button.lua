--[[
Button
Exposes click functionality
]]

--DEBUG:
--contains debug code for testing at present

local lib
local button

button = {
	mousedown_in = function(self, event)
		print("mousedown_in!", event.lx, event.ly)
	end,

	mousedown_out = function(self, event)
		print("mousedown_out!", event.lx, event.ly)
	end,

	mousedown = function(self, event)
		print("mousedown!", event.x, event.y)
		self.event_mousedown(event)
	end,

	mouseup_in = function(self, event)
		print("mouseup_in!", event.lx, event.ly)
	end,

	mouseup_out = function(self, event)
		print("mouseup_out!", event.lx, event.ly)
	end,

	mouseup = function(self, event)
		print("mouseup!", event.x, event.y)
		self.event_mouseup(event)
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(engine:lib_get(":ui.rectangle"))

		self.event_mousedown = lib.event.functor:new()
		self.event_mouseup = lib.event.functor:new()
	end,
}

return button