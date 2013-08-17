--[[
Ussuri 1.4.1 Test
]]

local ussuri = require("ussuri")

ussuri.start = function(engine, args)
	local lib = ussuri.lib

	local queue = lib.misc.timed_queue:new()

	ussuri.event:event_hook_light("keydown", {}, function(self, event)
		queue:queue(1, queue.LOCKINGABLE,
			function()
				print("pre")
			end
		)
	end)

	ussuri.event:event_hook_object(nil, queue)
	ussuri.event:event_hook_object(nil, lib.debug.monitor)
end