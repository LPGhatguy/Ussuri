function love.conf(t)
	t.title = "Ussuri Demo"
	t.author = "LPGhatguy"
	t.url = "https://github.com/LPGhatguy/Ussuri"
	t.identity = "Ussuri-Demo"
	t.version = "0.8.0"
	t.console = true
	t.release = false
	t.screen.width = 1024
	t.screen.height = 768
	t.screen.fullscreen = false
	t.screen.vsync = true
	t.screen.fsaa = 0
	t.modules.joystick = true
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.physics = true
end