--[[
Object Orientation
Enables instantation and inheritance of objects
]]

local lib, table_deepcopy, table_merge
local oop

oop = {
	objectify = function(self, to)
		table_merge(self.object, to)
	end,

	object = {
		inherit = function(self, from)
			if (from) then
				table_merge(from, self, true)

				return from
			else
				print("Cannot inherit from nil! (id: " .. tostring(base) .. ")")
			end
		end,
		new = function(self, ...)
			if (self._new) then
				return self:_new(...)
			else
				return self:copy()
			end
		end,
		copy = function(self)
			return table_deepcopy(self, {}, true)
		end
	},

	init = function(self, engine)
		lib = engine.lib
		table_deepcopy = lib.utility.table_deepcopy
		table_merge = lib.utility.table_merge

		self:objectify(engine)
	end
}

return oop