--[[
Ussuri 1.3.5 Demo
Current testing: ui: textbox
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib
	
	local ui_root = lib.ui.ui_container:new()
	ussuri.event:event_hook_object(nil, ui_root)
	ussuri.event:event_sort()
end