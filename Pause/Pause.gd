extends Control
signal dpad
signal joystick
signal keyboard

func _ready():
	pass

func _process(delta):
	if !$InputLabel/JoystickCheck.button_pressed and !$InputLabel/DpadCheck.button_pressed:
		keyboard.emit()

func _on_joystick_check_pressed():
	joystick.emit()
	if $InputLabel/DpadCheck.toggle_mode:
		$InputLabel/DpadCheck.button_pressed = false

func _on_dpad_check_pressed():
	dpad.emit()
	if $InputLabel/JoystickCheck.toggle_mode:
		$InputLabel/JoystickCheck.button_pressed = false

func _on_audio_check_pressed():
	var music_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))


func _on_about_me_button_pressed():
	OS.shell_open("https://github.com/Joeru-san")
