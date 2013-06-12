--[[
General Utility Library
Contains methods used by much of the engine
]]

local utility

utility = {
	DESCENDENTS_ONLY = 1,

	string_split = function(from, splitter)
		local last = 1
		local current
		local out = {}

		while (true) do
			current = from:find(splitter, last, true)

			if (not current) then
				break
			end

			table.insert(out, from:sub(last, current - 1))
			last = current + splitter:len()
		end

		table.insert(out, from:sub(last))

		return out
	end,

	table_contains = function(from, search)
		for key, value in next, from do
			if (rawequal(value, search)) then
				return true
			end
		end

		return false
	end,

	table_equals = function(first, second)
		if (second and type(first) == "table" and type(second) == "table") then
			for key, value in pairs(first) do
				local success = false

				if (type(value) == type(second[key])) then
					if (type(value) == "table") then
						success = utility.table_equals(value, second[key])
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
	end,

	table_pop = function(from, key)
		local key = key or 1
		local value = rawget(from, key)

		if (type(key) == "number") then
			table.remove(from, key)
		else
			rawset(from, key, nil)
		end

		return value
	end,

	table_deepcopy = function(from, to, meta, passed)
		local to = to or {}
		local passed = passed or {[from] = to, [to] = to}
		local child_meta = (meta == utility.DESCENDENTS_ONLY) and true or meta

		for key, value in pairs(from) do
			if (type(value) == "table") then
				if (next(value) == nil) then
					to[key] = {}
				elseif (rawget(value, "__")) then
					to[key] = value
				else
					if (rawget(passed, value) ~= nil) then
						rawset(to, key, rawget(passed, value))
					else
						local target = {}
						rawset(passed, value, target)

						utility.table_deepcopy(value, target, child_meta, passed)

						rawset(to, key, target)
					end
				end
			else
				to[key] = value
			end
		end

		if (meta == true) then
			setmetatable(to, getmetatable(from))
		end

		return to
	end,

	table_deepcopy_fast = function(from, to)
		local to = to or {}

		for key, value in pairs(from) do
			if (type(value) == "table") then
				rawset(to, key, utility.table_deepcopy_fast(value))
			else
				rawset(to, key, value)
			end
		end

		if (meta == true) then
			setmetatable(to, getmetatable(from))
		end

		return to
	end,

	table_copy = function(from, to, meta)
		local to = to or {}

		for key, value in pairs(from) do
			rawset(to, key, value)
		end

		if (meta == true) then
			setmetatable(to, getmetatable(from))
		end

		return to
	end,

	table_deepmerge = function(from, to, meta, merge_children, passed)
		local passed = passed or {[from] = to, [to] = to}
		local child_meta = (meta == utility.DESCENDENTS_ONLY) and true or meta

		for key, value in pairs(from) do
			if (rawget(to, key) ~= nil) then
				local target = rawget(to, key)

				if (type(value) == "table" and type(target) == "table") then
					if (merge_children) then
						utility.table_deepmerge(value, target, child_meta, passed)
					else
						utility.table_deepcopy(value, target, child_meta, passed)
					end
				end
			else
				if (type(value) == "table") then
					local target = {}
					rawset(to, key, target)

					utility.table_deepcopy(value, target, child_meta, passed)
				else
					rawset(to, key, value)
				end
			end
		end

		if (meta == true) then
			setmetatable(to, getmetatable(from))
		end

		return to
	end,

	table_merge = function(from, to, meta)
		for key, value in pairs(from) do
			if (rawget(to, key) == nil) then
				rawset(to, key, value)
			end
		end

		if (meta == true) then
			setmetatable(to, getmetatable(from))
		end

		return to
	end,

	--todo: make this less god-awful
	table_tree = function(location, level, max_depth)
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
	end,

	table_size = function(from, recursive)
		local size = 0

		if (recursive) then
			for key, value in next, from do
				size = size + 1
				if (type(value) == "table") then
					size = size + utility.table_size(value, true)
				end
			end
		else
			for key, value in next, from do
				size = size + 1
			end
		end
	end,

	init = function(self, engine)
		return self
	end
}

return utility