return {
	--details
	version = 1.2,
	--core
	engine_path = nil, --filled in by engine initialization
	lib_core = {":core.utility", ":core.oop", ":core.logging", ":core.event_manage", ":core.event_def", ":core.lib_manage", ":core.shorthand"},
	--core.lib_manage
	lib_folders = {
		{":misc", {"state_machine"}},
		{":input", {}},
		{":gui", {}},
		{":debug", {}}
	},
	--core.logging
	log_realtime_enabled = true,
	log_history_enabled = true,
	log_recording_enabled = false,
	log_directory = "logs"
}