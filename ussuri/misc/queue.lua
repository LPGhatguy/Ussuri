local queue = {}
local lib, table_pop

queue.time = 0
queue.elapsed = 0
queue.acting = false
queue.enabled = true
queue.stack = {}

queue.queue_update = function(self, event)
	if (self.enabled) then
		if (self.acting) then
			self.elapsed = self.elapsed + event.delta

			if (self.elapsed > self.time) then
				print(self.elapsed)
				self.elapsed = 0
				self:queue_step()
			end
		elseif (#self.stack > 0) then
			self:queue_step()
		end
	end
end

queue.queue_step = function(self)
	local stack = self.stack

	if (#stack > 0) then
		local action = table_pop(self.stack)

		local state = table_pop(action)

		if (type(state) == "string") then
			local time = tonumber(table_pop(action))
			local method = table_pop(action)

			self.acting = true
			if (state) then
				self:set_state(state)
			end

			if (time) then
				self.time = time
			end

			if (method) then
				method(unpack(action))
			end
		elseif (type(state) == "function") then
			self.time = 0
			self.elapsed = 0
			self.acting = false
			state(unpack(action))
		end
	else
		self.acting = false
		self:set_state("")
	end
end

queue.queue = function(self, ...)
	for key, value in next, {...} do
		table.insert(self.stack, value)
	end
end

queue.post = {
	update = queue.queue_update
}

queue.init = function(self, engine)
	lib = engine.lib
	table_pop = lib.utility.table_pop

	lib.oop:objectify(self)
	self:inherit(lib.misc.state_machine)

	return self
end

return queue