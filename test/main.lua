--[[
Ussuri 1.3.4 Demo
Current testing: class templating
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	--[[
	local ui_root = lib.ui.ui_container:new()
	ussuri.event:event_hook_object(nil, ui_root)
	ussuri.event:event_sort()
	]]

	local templating = lib.debug.templating
	local all = templating.construct.all
	local any = templating.construct.any
	local member = templating.construct.member
	local range = templating.construct.range
	local boolean = templating.construct.boolean
	local increment = templating.construct.increment
	local typa = templating.construct.type_any

	local verifier = {
		x = all(typa("number"), range(0)),
		y = all(typa("number"), range(0)),
		width = all(typa("number"), range(0)),
		height = all(typa("number"), range(0)),
		border_width = all(typa("number"), range(0)),
	}

	local result = templating:verify_object(lib.ui.rectangle, verifier)

	print(lib.utility.table_tree(result))
end