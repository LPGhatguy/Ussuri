local engine = require("engine.core")

function love.load()
	engine:init()

	local lib = engine.lib
	local extend = lib.extend

	local manager = extend.debris_manager()
	manager.update_child = function(self, child, delta)
		child.x = child.x + child.v_x * delta
		child.y = child.y + child.v_y * delta
	end
	manager.destroy_child = function(self, child)
		self.children[child] = nil
	end

	engine:event_hook("update", extend.delay:new(0.05, function(self)
		manager.children[{x = 300, y = 300, v_x = math.random(-70, 70), v_y = math.random(-70, 70)}] = 5
		self:delay_reset()
	end))

	engine:event_hook("update", manager)

	engine:event_hook("draw", function(self)
		for object, time_left in next, manager.children do
			love.graphics.print(math.ceil(time_left), object.x, object.y)
		end
	end)

	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			event.cancel = true
			love.event.push("quit")
		end
	end)
end

function love.keypressed(key, unicode)
	engine:fire_keydown(key, unicode)
end

function love.update(delta)
	engine:fire_update(delta)
end

function love.draw()
	engine:event_trigger("draw")
end

function love.quit()
	engine:close()
end