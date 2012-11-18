--requires engine.utility
local oop = {}
local object = {}
local lib

oop.object = object

oop.objectify = function(self, to, lightweight)
	lib.utility.table_merge(self.object, to)

	if (not lightweight) then
		to.__type = to.__type or "object"
	end
end

object.inherit = function(self, from)
	lib.utility.table_merge(from, self)
end

oop.init = function(self, engine)
	lib = engine.lib

	object.new = lib.utility.table_copy

	self:objectify(engine)

	return self
end

return oop