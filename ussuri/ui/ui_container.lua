--[[
UI Container
Holds UI objects and passes calls to them
]]

local lib
local container
local ui_base
local ui_container

ui_container = {
	clip_children = true,

	auto_hook = {
		["draw"] = true,
		["mousedown"] = true, ["mousedown_in"] = true, ["mousedown_out"] = true,
		["mouseup"] = true, ["mouseup_in"] = true, ["mouseup_out"] = true
	},

	draw = function(self, event)
		local tx = event.tx and (event.tx + self.x) or self.x
		local ty = event.ty and (event.ty + self.y) or self.y

		local handlers = self.events["draw"]
		local event_data = handlers.data
		event_data:update(data)
		event_data:add(self)

		local flags = event_data.flags
		local tx = event.tx and (event.tx + self.x) or self.x
		local ty = event.ty and (event.ty + self.y) or self.y

		event_data.tx = tx
		event_data.ty = ty

		love.graphics.push()
		love.graphics.translate(tx, ty)

		if (self.clip_children) then
			love.graphics.setScissor(tx, ty, self.width, self.height)
		end

		for key = 1, #handlers do
			local handler = handlers[key]

			handler[2](handler[1], event_data)

			if (flags.event_unhook) then
				handlers[key] = nil
				flags.event_unhook = false
			end

			if (flags.event_cancel) then
				break
			end
		end

		love.graphics.setScissor()
		love.graphics.pop()

		return event_data
	end,

	positional_event = function(self, event_name, event)
		self:event_fire(event_name, event)

		local lx = event.lx and (event.lx - self.x) or (event.x - self.x)
		local ly = event.ly and (event.ly - self.ly) or (event.y - self.y)

		local handlers = self.events[event_name .. "_out"]
		local event_data = handlers.data
		event_data:update(event)
		event_data:add(self)
		event_data.lx, event_data.ly = lx, ly

		local flags = event_data.flags

		for key = 1, #handlers do
			local handler = handlers[key]
			local object = handler[1]

			if (lx < object.x or ly < object.y or
				lx > (object.x + object.width) or ly > (object.y + object.height)) then
				handler[2](handler[1], event_data)
			end

			if (flags.event_unhook) then
				handlers[key] = nil
				flags.event_unhook = false
			end

			if (flags.event_cancel) then
				break
			end
		end

		if (not self.clip_children) then
			local handlers = self.events[event_name .. "_in"]
			local event_data = handlers.data
			event_data:update(event)
			event_data:add(self)
			event_data.lx, event_data.ly = lx, ly

			local flags = event_data.flags

			for key = 1, #handlers do
				local handler = handlers[key]
				local object = handler[1]

				if (lx > object.x and ly > object.y and
					lx < (object.x + object.width) and ly < (object.y + object.height)) then

					handler[2](handler[1], event_data)
				end

				if (flags.event_unhook) then
					handlers[key] = nil
					flags.event_unhook = false
				end

				if (flags.event_cancel) then
					break
				end
			end
		end
	end,

	positional_event_in = function(self, event_name, event)
		if (self.clip_children) then
			local handlers = self.events[event_name .. "_in"]
			local event_data = handlers.data
			event_data:update(event)
			event_data:add(self)

			local lx = event.lx and (event.lx - self.x) or (event.x - self.x)
			local ly = event.ly and (event.ly - self.y) or (event.y - self.y)

			event_data.lx, event_data.ly = lx, ly

			local flags = event_data.flags

			for key = 1, #handlers do
				local handler = handlers[key]
				local object = handler[1]

				if (lx > object.x and ly > object.y and
					lx < (object.x + object.width) and ly < (object.y + object.height)) then

					handler[2](handler[1], event_data)
				end

				if (flags.event_unhook) then
					handlers[key] = nil
					flags.event_unhook = false
				end

				if (flags.event_cancel) then
					break
				end
			end

			return event_data
		end
	end,

	mousedown = function(self, event)
		self:positional_event("mousedown", event)
	end,

	mousedown_in = function(self, event)
		self:positional_event_in("mousedown", event)
	end,

	mouseup = function(self, event)
		self:positional_event("mouseup", event)
	end,

	mouseup_in = function(self, event)
		self:positional_event_in("mouseup", event)
	end,

	_new = function(base, new, x, y, w, h)
		container._new(base, new)
		ui_base._new(base, new, x, y, w, h)

		return new
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		container = self:inherit(engine:lib_get(":event.container"))
		ui_base = self:inherit(engine:lib_get(":ui.base"))
	end
}

ui_container.event = {
	draw = ui_container.draw,
	mousedown = ui_container.mousedown,
	mousedown_in = ui_container.mousedown_in,
	mouseup = ui_container.mouseup,
	mouseup_in = ui_container.mouseup_in
}

return ui_container