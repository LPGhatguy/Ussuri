return {
	version = 1.3,

	lib_core = {":core.utility", ":core.oop", ":core.logging", ":core.event_manage", ":core.event_def", ":core.lib_manage"},

	lib_folders = {
		{":extend", {}},
		{":misc", {"state_machine"}},
		{":input", {}},
		{":gui", {"base", "container"}},
		{":debug", {}}
	},

	log_realtime_enabled = true,
	log_history_enabled = true,
	log_recording_enabled = false,
	log_directory = "logs"
}