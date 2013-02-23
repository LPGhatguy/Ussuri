--[[
GUI Container
A GUI item that contains other items
Inherits gui.base
]]

local lib
local container
local point_in_item

container = {
	clips_children = false,
	children = {},
	padding_x = 0,
	padding_y = 0,

	add = function(self, object)
		table.insert(self.children, object)
	end,

	register = function(self, key, object)
		self.children[key] = object
	end,

	remove = function(self, key)
		self.children[key] = nil
	end,

	draw = function(self)
		love.graphics.push()
		love.graphics.setColor(255, 255, 255)
		love.graphics.translate(self.x, self.y)

		if (self.clips_children) then
			--TODO: Visually clip children
		end

		for key, child in next, self.children do
			child:draw()
		end

		love.graphics.setScissor()
		love.graphics.pop()
	end,

	mousedown = function(self, event)
		local mouse_x, mouse_y = event.x, event.y
		local trans_x, trans_y = event.x - self.x, event.y - self.y

		if (self.visible and point_in_item(self, mouse_x, mouse_y)) then
			for key, child in next, self.children do
				if (child.mousedown and child.visible and point_in_item(child, trans_x, trans_y)) then

					event.x = trans_x
					event.y = trans_y
					child:mousedown(event)
					break
				end
			end
		end

		event.x = mouse_x
		event.y = mouse_y
	end,

	init = function(self, engine)
		lib = engine.lib

		point_in_item = lib.gui.point_in_item

		lib.oop:objectify(self)
		self:inherit(lib.gui.base, true)
	end
}

container.event = {
	draw = container.draw,
	mousedown = container.mousedown
}

return container