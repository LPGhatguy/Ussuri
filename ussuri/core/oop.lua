--[[
Object Orientation
Enables instantation and inheritance of objects
]]

local lib, table_copy, table_merge
local oop

oop = {
	objectify = function(self, to)
		lib.utility.table_merge(self.object, to)
	end,

	object = {
		inherit = function(self, from)
			table_merge(from, self, true)
		end,
		_new = function(self)
			return table_copy(self, {}, true)
		end
	},

	init = function(self, engine)
		lib = engine.lib
		table_copy = lib.utility.table_copy
		table_merge = lib.utility.table_merge

		self.object.new = self.object._new

		self:objectify(engine)

		return self
	end
}

return oop