--[[
Ussuri 1.4.0 Test
]]

local ussuri = require("ussuri")

ussuri.start = function(engine, args)
	local lib = ussuri.lib

	print(ussuri.lib.debug.unit:test())
end