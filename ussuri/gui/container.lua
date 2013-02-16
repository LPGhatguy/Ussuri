--[[
GUI Container
A GUI item that contains other items
Inherits gui.base
]]

local lib
local container

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
		love.graphics.translate(self.x + self.padding_x, self.y + self.padding_y)

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
		local mx, my = event.x, event.y
		local mouse_x, mouse_y = event.x - self.x - self.padding_x, event.y - self.y - self.padding_y

		if (self.visible and not self.clips_children or (mouse_x > 0 and mouse_x < self.width) and (mouse_y > 0 and mouse_y < self.height)) then
			for key, child in next, self.children do
				if (child.mousedown and child.visible and
				(mouse_x > child.x and mouse_x < child.x + child.width) and
				(mouse_y > child.y and mouse_y < child.y + child.height)) then

					event.x = mouse_x
					event.y = mouse_y
					child:mousedown(event)
					break
				end
			end
		end

		event.x = mx
		event.y = my
	end,

	init = function(self, engine)
		lib = engine.lib

		lib.oop:objectify(self)
		self:inherit(lib.gui.base, true)
	end
}

container.event = {
	draw = container.draw,
	mousedown = container.mousedown
}

return container