--[[
LÖVE Binds
Extends the engine by providing interfaces to certain LÖVE methods with additional functionality
]]

local definitions

definitions = {
	set_display_mode = function(self, ...)
		local out = self:fire_display_updating(...)

		if (not out.cancel) then
			if (love.graphics.setMode(...)) then
				self:fire_display_updated(...)
			end
		end
	end,	

	init = function(self, engine)
		engine:inherit(self)
	end
}

return definitions