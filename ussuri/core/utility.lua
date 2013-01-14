--[[
General Utility Library
Includes useful methods otherwise defined as boilerplate without modifying existing libraries
Written by Lucien Greathouse
]]

local utility = {}

utility.do_nothing = function()
end

utility.get_engine_path = function()
	return debug.getinfo(1).short_src:match("([^%.]*)[\\/][^%.]*%..*$")
end

utility.string_split = function(source, splitter)
	local last, current = 1
	local out = {}

	while (true) do
		current = source:find(splitter, last, true)

		if (not current) then
			break
		end

		table.insert(out, source:sub(last, current - 1))
		last = current + splitter:len()
	end

	table.insert(out, source:sub(last))

	return out
end

utility.table_contains = function(from, search)
	for key, value in next, from do
		if (value == search) then
			return true
		end
	end

	return false
end

utility.table_compare = function(first, second)
	if (second) then
		for key, value in pairs(first) do
			local success = false

			if (type(value) == type(second[key])) then
				if (type(value) == "table") then
					success = utility.table_compare(value, second[key])
				else
					success = (second[key] == value)
				end
			end
			
			if (not success) then
				return false
			end
		end

		return true
	else
		return false
	end
end

utility.table_pop = function(from, key)
	local key = key or 1
	local value = from[key]

	if (type(key) == "number") then
		table.remove(from, key)
	else
		from[key] = nil
	end

	return value
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

utility.table_tree = function(location, level, max_depth)
	local out = ""
	local level = level or 0
	local max_depth = max_depth or 6

	for key, value in next, location do
		out = out .. ("\t"):rep(level) ..
			"(" .. type(key) .. ") " ..
			tostring(key) .. ": "

		if (type(value) == "string") then
			out = out .. "\"" .. value .. "\""
		elseif (type(value) == "table") then
			if (level < max_depth) then
				out = out .. "(table)\n" .. utility.table_tree(value, level + 1, max_depth)
			end
		elseif (type(value) == "function") then
			out = out .. "(" .. tostring(value):gsub("00+", "") .. ")"
		else
			out = out .. tostring(value)
		end

		out = out .. "\n"
	end

	return out:sub(1, -2)
end

utility.table_size = function(the_table, recursive)
	local size = 0

	if (recursive) then
		for key, value in next, the_table do
			size = size + 1
			if (type(value) == "table") then
				size = size + utility.table_size(value, true)
			end
		end
	else
		for key, value in next, the_table do
			size = size + 1
		end
	end

	return size
end

utility.init = function(self, engine)
	return self
end

return utility