--[[
Object Orientation
Enables instantation and inheritance of objects
Written by Lucien Greathouse
]]

local oop = {}
local object = {}
local lib

oop.object = object

object.inherit = function(self, from)
	lib.utility.table_merge(from, self)
end

oop.objectify = function(self, to)
	lib.utility.table_merge(self.object, to)
end

oop.init = function(self, engine)
	lib = engine.lib

	object._new = lib.utility.table_copy --base constructor
	object.new = object._new --default constructor

	self:objectify(engine)

	return self
end

return oop