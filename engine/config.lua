return {
	--details
	version = 1.1,
	--core
	engine_path = nil, --filled in by engine initialization
	--core.lib_manage
	lib_core = {":core.utility", ":core.oop", ":core.logging", ":core.event", ":core.event_def", ":core.lib_manage", ":core.shorthand"},
	lib_folders = {
		[":extend"] = {},
		[":misc"] = {},
		[":debug"] = {},
		[":input"] = {},
		[":gui"] = {}
	},
	--core.logging
	log_realtime_enabled = true,
	log_history_enabled = true,
	log_recording_enabled = false,
	log_directory = "logs"
}