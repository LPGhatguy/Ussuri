--requires engine.utility
local oop = {}
local object = {}
local lib

oop.object = object

oop.objectify = function(self, to, lightweight)
	lib.utility.table_merge(self.object, to)

	if (not lightweight) then
		to.__type = to.__type or "object"

		local meta = getmetatable(to) or {}
		if (getmetatable(to)) then
			if (not getmetatable(to).__call) then
				getmetatable(to).__call = to._metanew
			end
		else
			setmetatable(to, {
				__call = to._metanew
			})
		end
	end
end

object.inherit = function(self, from)
	lib.utility.table_merge(from, self)
end

oop.init = function(self, engine)
	lib = engine.lib

	object._new = lib.utility.table_copy --base constructor
	object.new = object._new --default constructor
	object._metanew = function(...) --hacky metatable trick
		return self.new(...)
	end

	self:objectify(engine)

	return self
end

return oop