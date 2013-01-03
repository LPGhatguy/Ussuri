--[[
Object Orientation
Enables instantation and inheritance
Written by Lucien Greathouse
]]

local oop = {}
local object = {}
local lib

oop.object = object

object.inherit = function(self, from)
	lib.utility.table_merge(from, self)
end

oop.objectify = function(self, to, lightweight)
	lib.utility.table_merge(self.object, to)

	if (not lightweight) then
		to.__type = to.__type or "object"

		local meta = getmetatable(to)
		if (meta) then
			if (not meta.__call) then
				meta.__call = to._metanew
			end
		else
			setmetatable(to, {
				__call = to._metanew
			})
		end
	end
end

oop.init = function(self, engine)
	lib = engine.lib

	object._new = lib.utility.table_copy --base constructor
	object.new = object._new --default constructor
	object._metanew = function(self, ...) --hacky metatable trick
		return self.new(self, ...)
	end

	self:objectify(engine)

	return self
end

return oop