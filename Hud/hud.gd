extends CanvasLayer

# Notifica la scena main che il bottone è stato premuto
signal start_game
signal pause_game
var joystick_enabled : bool = false
var pause_state : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(latest_score):
	if OS.has_feature("android") or OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
		$Input/Dpad.hide()
		$Input/VirtualJoystick.hide()
	$PauseButton.hide()
	$Pause.hide()
	show_message("Game Over")
	# Aspetta fin quando il WaitTimer ha finito
	await $MessageTimer.timeout
	
	$LastScore.text = str(latest_score)
	self.update_score(0);
	$Message.text = "Dodge the Creeps"
	$Message.show()
	
	# Facciamo un timer one shot, cioè che non è un nodo e verrà chiamato solo quando partirà il game over
	# In questo modo non ci facciamo un nodo in più
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func on_pause_button_pressed():
	pause_state = !pause_state
	if pause_state:
		pause_game.emit()
		$PauseButton.text = "▶️"
		$Pause.show()
		$ColorRect.show()
		$Message.hide()
		$Input.hide()
		if OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile") or OS.has_feature("android"):
			$Pause/InputLabel.show()
		else:
			$Pause/InputLabel.hide()
	else:
		pause_game.emit()
		$PauseButton.text = "||"
		$Pause.hide()
		$ColorRect.hide()
		$Input.show()
		if OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile") or OS.has_feature("android"):
			$Pause.hide()

func _on_start_button_pressed():
	if OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile") or OS.has_feature("android"):
		if joystick_enabled:
			$Input/VirtualJoystick.show()
			$Input/Dpad.deactivate()
		else:
			$Input/Dpad.show()
	$StartButton.hide()
	$PauseButton.show()
	$PowerUpLabel.text = ""
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func _on_pause_dpad():
	$Input/VirtualJoystick.deactivate()
	$Input/VirtualJoystick.hide()
	$Input/Dpad.show()
	$Input/Dpad.activate()

func _on_pause_joystick():
	$Input/VirtualJoystick.activate()
	$Input/VirtualJoystick.show()
	$Input/Dpad.hide()
	joystick_enabled = true

func _on_pause_keyboard():
	$Input/VirtualJoystick.hide()
	$Input/VirtualJoystick.deactivate()
	$Input/Dpad.hide()
	$Input/Dpad.deactivate()
