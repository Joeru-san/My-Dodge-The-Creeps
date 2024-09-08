extends Area2D
signal hit
signal shield
signal time
signal fast

@export var speed = 400
var screen_size
var can_move = true
var velocity

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	if not can_move:
		return
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
			velocity.x += 1
	if Input.is_action_pressed("move_left"):
			velocity.x -= 1
	if Input.is_action_pressed("move_down"):
			velocity.y += 1
	if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_body_entered(body):
	if body.get_groups()[0] == "mobs":
		can_move = false
		hit.emit()
		await get_tree().create_timer(1.0).timeout
		hide()
		can_move = true
		$CollisionShape2D.set_deferred("disabled", true)
	elif body.get_groups()[0] == "powerup":
		var powerup = body.get_node("AnimatedSprite2D")
		if powerup.animation == "time":
			time.emit()
		elif powerup.animation == "shield":
			shield.emit()
			$PowerUpTexture.show()
			$CollisionShape2D.set_deferred("disabled", true)
			await get_tree().create_timer(5.0).timeout
			$CollisionShape2D.set_deferred("disabled", false)
			$PowerUpTexture.hide()
		elif powerup.animation == "fast":
			fast.emit()
			speed = 550
			await get_tree().create_timer(6.0).timeout
			speed = 400

func start(pos):
	position = pos
	$AnimatedSprite2D.animation = "walk"
	show()
	$CollisionShape2D.disabled = false
