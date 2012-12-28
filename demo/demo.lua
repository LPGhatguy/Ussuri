local lib, extend

function love.load()
	engine = require("engine.core")
	engine:init()

	print = function(...)
		engine:log_write("{o}", ...)
	end

	lib = engine.lib
	extend = lib.extend

	--initialize the particle class
	time_particle = {
		x = 0,
		y = 0,
		v_x = 0,
		v_y = 0,
		color = {0, 0, 0},
		new = function(self, x, y)
			local particle = self:_new()

			particle.x = x
			particle.y = y
			particle.v_x = math.random(-70, 70)
			particle.v_y = math.random(-70, 70)
			particle.color = {math.random(100, 200), math.random(100, 200), math.random(100, 200)}

			return particle
		end
	}
	lib.oop:objectify(time_particle, true)

	--initialize the particle manager class
	particle_manager = {
		elapsed = 0,
		x = 0,
		y = 0,
		update_child = function(self, child, delta)
			child.x = child.x + child.v_x * delta
			child.y = child.y + child.v_y * delta
		end
	}

	lib.oop:objectify(particle_manager)
	particle_manager:inherit(extend.debris_manager)

	particle_manager.event.update = function(self, event)
		self.elapsed = self.elapsed + event.delta
		self.x = 512 + 256 * math.cos(self.elapsed)
		self.y = 384 + 192 * math.sin(self.elapsed)

		self:debrismanage_step(event.delta)
	end

	particle_manager.event.draw = function(self)
		love.graphics.setColor(200, 0, 0)
		love.graphics.circle("fill", self.x, self.y, 3)

		for object, time_left in next, self.children do
			love.graphics.setColor(object.color)
			love.graphics.print(math.ceil(time_left), object.x, object.y)
		end
	end

	--create our manager and hook it into the engine
	manager = particle_manager:new()
	engine:event_hook_auto(manager)

	--create a spawner loop to create particles for the manager
	engine:event_hook("update", extend.delay:new(0.05, function(self)
		manager.children[time_particle:new(manager.x, manager.y)] = 5
		self:delay_reset()
	end))

	--enable debug monitor and console functionality (both WIP)
	engine:event_hook_auto(lib.debug.debug_monitor)
	engine:event_hook_auto(lib.debug.console)

	--allow the user to quit
	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			if (love.keyboard.isDown("`")) then
				engine:log_write(lib.utility.table_tree(engine))
				engine.config.log_recording_enabled = true
			end

			event.cancel = true
			love.event.push("quit")
		end
	end, nil, 0)

	--shake the screen for fun
	engine:event_hook("keydown", function(self, event)
		if (event.key == " ") then
			local shake = extend.debris:new(2)
			shake.rotation = 0

			shake.debris_update = function(self, delta)
				self.rotation = math.random(-50, 50) / 5000
			end

			shake.event.draw = function(self, event)
				love.graphics.rotate(self.rotation)

				event.unhook = not self.debris_alive
			end

			shake.event_priority = {
				draw = 0
			}

			engine:event_hook_auto(shake)
		end
	end)
end

--wire up events for the engine to catch
function love.keypressed(key, unicode)
	engine:fire_keydown(key, unicode)
end

function love.mousepressed(x, y, button)
	engine:fire_mousedown(x, y, button)
end

function love.mousereleased(x, y, button)
	engine:fire_mouseup(x, y, button)
end

function love.update(delta)
	engine:fire_update(delta)
end

function love.draw()
	engine:fire_draw()
end

function love.quit()
	engine:close()
end