return {
	version = {1, 1, 0},

	lib_core = {":core.utility", ":core.oop", ":core.logging", ":core.event_manage", ":core.event_def", ":core.lib_manage"},

	lib_folders = {
		{":utility", {"state_machine"}},
		{":input", {}},
		{":ui", {"base", "container", "rectangle"}},
		{":debug", {}}
	},

	log_realtime_enabled = true,
	log_history_enabled = true,
	log_recording_enabled = false,
	log_directory = "logs"
}