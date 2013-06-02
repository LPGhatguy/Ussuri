--[[
UI Container
Holds UI objects and passes calls to them
]]

local lib
local container
local ui_base
local ui_container

ui_container = {
	auto_hook = {["draw"] = true,
		["mousedown"] = true, ["mousedown_in"] = true, ["mousedown_out"] = true,
		["mouseup"] = true, ["mouseup_in"] = true, ["mouseup_out"] = true},

	draw = function(self, event)
		--todo: element clipping

		love.graphics.push()
		love.graphics.translate(self.x, self.y)

		self:event_fire("draw", event)

		love.graphics.pop()
	end,

	mousedown = function(self, event)
		self:event_fire("mousedown", event)

		local mx, my = event.x, event.y

		--if event.lx/ly are undefined, this is a top-level handler
		local lmx = event.lx or (event.x - self.x)
		local lmy = event.ly or (event.y - self.y)

		local in_handlers = self.events["mousedown_in"]
		local in_data = in_handlers.data
		local in_flags = in_data.flags

		local out_handlers = self.events["mousedown_out"]
		local out_data = out_handlers.data
		local out_flags = out_data.flags

		for key = 1, #in_handlers do
			local handler = in_handlers[key]

			local item = handler[1]
			if (lmx > item.x and lmy > item.y and lmx < (item.x + item.width) and lmy < (item.y + item.height)) then
				in_data.lx = lmx
				in_data.ly = lmy
				handler[2](handler[1], in_data)
			end

			if (in_flags.event_unhook) then
				event[key] = nil
				in_flags.event_unhook = false
			end

			if (in_flags.event_cancel) then
				break
			end
		end

		for key = 1, #out_handlers do
			local handler = out_handlers[key]

			local item = handler[1]
			if (lmx < item.x or lmy < item.y or lmx > (item.x + item.width) or lmy > (item.y + item.height)) then
				out_data.lx = lmx
				out_data.ly = lmy
				handler[2](handler[1], out_data)
			end

			if (out_flags.event_unhook) then
				event[key] = nil
				out_flags.event_unhook = false
			end

			if (out_flags.event_cancel) then
				break
			end
		end
	end,

	--This is the same code as mousedown with "down" replaced with "up"
	--TODO: less repetitive code
	mouseup = function(self, event)
		self:event_fire("mouseup", event)

		local mx, my = event.x, event.y

		--if event.lx/ly are undefined, this is a top-level handler
		local lmx = event.lx or (event.x - self.x)
		local lmy = event.ly or (event.y - self.y)

		local in_handlers = self.events["mouseup_in"]
		local in_data = in_handlers.data
		local in_flags = in_data.flags

		local out_handlers = self.events["mouseup_out"]
		local out_data = out_handlers.data
		local out_flags = out_data.flags

		for key = 1, #in_handlers do
			local handler = in_handlers[key]

			local item = handler[1]
			if (lmx > item.x and lmy > item.y and lmx < (item.x + item.width) and lmy < (item.y + item.height)) then
				in_data.lx = lmx
				in_data.ly = lmy
				handler[2](handler[1], in_data)
			end

			if (in_flags.event_unhook) then
				event[key] = nil
				in_flags.event_unhook = false
			end

			if (in_flags.event_cancel) then
				break
			end
		end

		for key = 1, #out_handlers do
			local handler = out_handlers[key]

			local item = handler[1]
			if (lmx < item.x or lmy < item.y or lmx > (item.x + item.width) or lmy > (item.y + item.height)) then
				out_data.lx = lmx
				out_data.ly = lmy
				handler[2](handler[1], out_data)
			end

			if (out_flags.event_unhook) then
				event[key] = nil
				out_flags.event_unhook = false
			end

			if (out_flags.event_cancel) then
				break
			end
		end
	end,

	_new = function(base, new, x, y, w, h)
		container._new(base, new)
		ui_base._new(base, new, x, y, w, h)

		return new
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)

		ui_base = self:inherit(engine:lib_get(":ui.base"))
		container = self:inherit(engine:lib_get(":event.container"))
	end
}

ui_container.event = {
	draw = ui_container.draw,
	mousedown = ui_container.mousedown,
	mouseup = ui_container.mouseup
}

return ui_container