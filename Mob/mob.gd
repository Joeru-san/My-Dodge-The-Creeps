extends RigidBody2D

var velocity : Vector2

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var chosen_animation = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play(chosen_animation)

	if chosen_animation == "fly":
		var direction = rotation + PI / 2 + randf_range(-PI / 4, PI / 4)
		rotation = direction
		velocity = Vector2(randf_range(175.0, 350.0), 0.0)
		linear_velocity = velocity.rotated(direction)
	elif chosen_animation == "walk":
		rotation = 0
		var spawn_position = position
		var walk_direction = -1
		$AnimatedSprite2D.flip_h = true
		if spawn_position.x < get_viewport().size.x / 2:
			walk_direction = 1  
			$AnimatedSprite2D.flip_h = false
		velocity = Vector2(randf_range(175.0, 350.0) * walk_direction, 0.0)
		linear_velocity = velocity

func _process(delta):
	pass

func stop_animation():
	$AnimatedSprite2D.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
