extends Control
signal dpad
signal joystick

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_joystick_check_pressed():
	joystick.emit()
	if $DpadCheck.toggle_mode:
		$DpadCheck.button_pressed = false


func _on_dpad_check_pressed():
	dpad.emit()
	if $JoystickCheck.toggle_mode:
		$JoystickCheck.button_pressed = false
