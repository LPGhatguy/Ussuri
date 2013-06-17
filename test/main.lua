--[[
Ussuri 1.3.3 Demo
Current testing: Localization and data binding
]]

local ussuri = require("ussuri")

function love.load()
	local lib = ussuri.lib

	local ui_root = lib.ui.ui_container:new()
	ussuri.event:event_hook_object(nil, ui_root)
	ussuri.event:event_sort()

	local langs = lib.content.languages
	local loc = lib.content.localization:new()

	loc:load_strings_from_directory("test/strings/")

	local languages = {}
	local current = 1
	for language in next, loc.strings do
		table.insert(languages, language)
	end

	loc:set_language(languages[current])

	local change_button = lib.ui.button:new(50, 50, 100, 30)
	change_button.event_mousedown_in:connect(function()
		current = current + 1
		if (current > #languages) then
			current = 1
		end

		loc:set_language(languages[current])
	end)

	local greetput = lib.ui.text_label:new("ERR", 50, 80, 100, 20)
	local clang = lib.ui.text_label:new("", 50, 100, 100, 20)

	loc:bind_string("hello", {greetput, "text"})
	loc:bind("language", function(key, value)
		clang.text = langs[value] or "ERR"
	end)

	ui_root:adds({change_button, greetput, clang})
end