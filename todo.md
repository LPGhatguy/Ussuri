Changes to note:
	-lib_manage no longer loads init.lua automatically; libraries the depend on their corresponding init.lua should lib_get() it manually

To do today and this weekend:

	DONE ON 2013/4/18:
	-Make stub library on load_lib (DONE)
	-Rewrite ussuri.event module (DONE)
	-Scrap debug.console, rewrite later (DONE)
	-Update basic ussuri.debug components (DONE)

	DONE ON 2013/4/20:
	-Establish core event priority number space like Dewey (DONE)
	-Rename ussuri.utility to demerge with ussuri.core.utility (DONE)
	-Normalize ussuri.core.logging (DONE)
	-Update core engine config format (DONE)

	-Rewrite ussuri.ui to match event module (IN PROGRESS MORE OR LESS)

To do sometime in the future:

	-Resource manager
	-Rewrite sound engine
	-Update unit tests for ussuri.core.utility
	-Expression bound variables
	-Expanded input module for easier bindings