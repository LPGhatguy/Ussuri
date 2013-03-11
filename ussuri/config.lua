return {
	version = {1, 1, 2, "DEV"},

	lib_core = {":core.utility", ":core.oop", ":core.logging", ":core.event_manage", ":core.event_def", ":core.love_binds", ":core.lib_manage"},

	lib_folders = {
		{":utility", {}},
		{":input", {}},
		{":ui", {"base", "ui_container", "rectangle"}},
		{":debug", {}}
	},

	log_realtime_enabled = true,
	log_history_enabled = true,
	log_recording_enabled = false,
	log_directory = "logs"
}