extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $TextureRect/down.is_pressed():
		$TextureRect.texture = load("res://Dpad/assets/Down_Dpad.png")
	elif $TextureRect/up.is_pressed():
		$TextureRect.texture = load("res://Dpad/assets/Up_Dpad.png")
	elif $TextureRect/left.is_pressed():
		$TextureRect.texture = load("res://Dpad/assets/Left_Dpad.png")
	elif $TextureRect/right.is_pressed():
		$TextureRect.texture = load("res://Dpad/assets/Right_Dpad.png")
	else:
		$TextureRect.texture = load("res://Dpad/assets/Base_Dpad.png")

func deactivate():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func activate():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
