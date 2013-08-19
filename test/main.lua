--[[
Ussuri 1.4.2 Test
]]

local ussuri = require("ussuri")

ussuri.start = function(engine, args)
	local lib = ussuri.lib

	local queue = lib.misc.timed_queue:new()

	ussuri.event:event_hook_light({x = 0}, "keydown",
		function(self, event)
			queue:queue(1, queue.LOCKINGABLE,
				function()
					self.x = self.x + 1
					print("FIRE!", self.x)
				end,
				function()
					print("READY TO FIRE!")
				end
			)
		end
	)

	ussuri.event:event_hook_object(queue)
	ussuri.event:event_hook_object(lib.debug.monitor)
end