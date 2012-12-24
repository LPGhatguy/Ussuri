local utility = {}

utility.do_nothing = function()
end

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

utility.table_merge = function(from, to)
	if (from) then
		for key, value in pairs(from) do
			if (not to[key]) then
				if (type(value) == "table") then
					to[key] = utility.table_copy(value)
				else
					to[key] = value
				end
			end
		end
	end

	return to
end

utility.table_merge_adv = function(from, to, transform)
	for key, value in pairs(from) do
		if (not to[key]) then
			local key, value = transform(key, value)
			if (type(value) == "table") then
				to[key] = utility.table_copy(value)
			else
				to[key] = value
			end
		end
	end
end

utility.table_tree = function(location, level)
	local out = ""
	local level = level or 0

	for key, value in next, location do
		out = out .. ("\t"):rep(level) ..
			"(" .. type(key) .. ") " ..
			tostring(key) .. ": "

		if (type(value) == "string") then
			out = out .. "\"" .. value .. "\""
		elseif (type(value) == "table") then
			out = out .. "(table)\n" .. utility.table_tree(value, level + 1)
		elseif (type(value) == "function") then
			out = out .. "(" .. tostring(value):gsub("00+", "") .. ")"
		else
			out = out .. tostring(value)
		end

		out = out .. "\n"
	end

	return out:sub(1, -2)
end

utility.init = function(self, engine)
	return self
end

return utility