--[[
Object Orientation
Enables instantation and inheritance of objects
]]

local oop = {}
local object = {}
local lib, table_copy, table_merge

oop.object = object

object.inherit = function(self, from)
	table_merge(from, self, true)
end

object._new = function(self)
	return table_copy(self, {}, true)
end

oop.objectify = function(self, to)
	lib.utility.table_merge(self.object, to)
end

oop.init = function(self, engine)
	lib = engine.lib
	table_copy = lib.utility.table_copy
	table_merge = lib.utility.table_merge

	object.new = object._new --default constructor

	self:objectify(engine)

	return self
end

return oop