return
{
	--core
	engine_path = nil, --filled in by engine initialization
	--core.lib_manage
	core_lib = {":core.utility", ":core.oop", ":core.logging", ":core.lib_manage"},
	engine_lib = {},
	--core.logging
	log_realtime_enabled = true,
	log_history_enabled = true,
	log_recording_enabled = false
}