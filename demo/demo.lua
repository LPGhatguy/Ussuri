--Load the engine
local engine = require("engine.core")

function love.load()
	--Initialize the engine and its libraries
	engine:init()

	--Make some shorthand references for efficiency
	local lib = engine.lib
	local extend = lib.extend

	--Create a debris manager to manage our particles
	local manager = extend.debris_manager()

	--Create a method to update our particles
	--The default destructor is fine, so we won't mess with it
	manager.update_child = function(self, child, delta)
		child.x = child.x + child.v_x * delta
		child.y = child.y + child.v_y * delta
	end

	--Wire up the particle spawner to the update event
	engine:event_hook("update", extend.delay:new(0.05, function(self)
		manager.children[{x = 300, y = 300, v_x = math.random(-70, 70), v_y = math.random(-70, 70)}] = 5
		self:delay_reset()
	end))

	--Wire up the manager to the update event
	engine:event_hook("update", manager)

	--Draw the particles to the screen!
	engine:event_hook("draw", function(self)
		for object, time_left in next, manager.children do
			love.graphics.print(math.ceil(time_left), object.x, object.y)
		end
	end)

	--This must be fired absolutely first, so we pass a priority of 0 so no escape keypressed fall through.
	engine:event_hook("keydown", function(self, event)
		if (event.key == "escape") then
			event.cancel = true
			love.event.push("quit")
		end
	end, nil, 0)

	--We don't care what order this gets fired, just that it does.
	engine:event_hook("keydown", function(self, event)
		engine:log_write(event.key, event.unicode)
	end)
end

--Everything below here is just to wire code up to the engine and fire events
function love.keypressed(key, unicode)
	engine:fire_keydown(key, unicode)
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