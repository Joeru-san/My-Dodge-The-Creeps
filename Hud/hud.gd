extends CanvasLayer

# Notifica la scena main che il bottone è stato premuto
signal start_game
signal pause_game
@export var pause_state : bool = false

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
		$Dpad.hide()
		$VirtualJoystick.hide()
	$PauseButton.hide()
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
		if OS.has_feature("android") or OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
			$Pause.show()
		pause_game.emit()
		$PauseButton.text = "▶️"
		$ColorRect.show()
	else:
		if OS.has_feature("android") or OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
			$Pause.hide()
		pause_game.emit()
		$PauseButton.text = "||"
		$ColorRect.hide()

func _on_start_button_pressed():
	if OS.has_feature("android") or OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
		$Dpad.show()
	$StartButton.hide()
	$PauseButton.show()
	$PowerUpLabel.text = ""
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func _on_pause_dpad():
	$VirtualJoystick.hide()
	$Dpad.show()

func _on_pause_joystick():
	$VirtualJoystick.show()
	$Dpad.hide()
