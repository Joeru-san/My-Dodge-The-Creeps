extends RigidBody2D

func _ready():
	var power_up_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(power_up_types[randi() % power_up_types.size()])
	
func _process(delta):
	pass

func stop_animation():
	$AnimatedSprite2D.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
