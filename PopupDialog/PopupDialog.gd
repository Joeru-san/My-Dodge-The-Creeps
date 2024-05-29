extends Control

func _ready():
	pass

func _process(delta):
	pass
	
func _on_confirm_button_pressed():
	get_tree().quit()

func _on_cancel_button_pressed():
	self.hide()
