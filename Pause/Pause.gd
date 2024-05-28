extends Control
signal dpad
signal joystick
signal keyboard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
