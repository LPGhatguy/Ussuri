local utility = {}

utility.get_engine_path = function()
	return debug.getinfo(1).short_src:match("([^%.]*)[\\/][^%.]*%..*$")
end

utility.table_copy = function(from, to)
	local to = to or {}

	for key, value in pairs(from) do
		if (type(value) == "table") then
			to[key] = utility.table_copy(value)
		else
			to[key] = value
		end
	end

	return to
end

utility.init = function(self)
	return self
end

return utility