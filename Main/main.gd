extends Node

@export var mob_scene: PackedScene
@export var powerup_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	# Clear all Vector2 points
	$MobPath.curve.clear_points()
	# Set 1st vector
	$MobPath.curve.add_point(Vector2(0,0))
	# Set 2nd vector
	$MobPath.curve.add_point(Vector2(screen_size.x, 0))
	# Set 3rd vector
	$MobPath.curve.add_point(Vector2(screen_size.x, screen_size.y))
	# Set 4th vector
	$MobPath.curve.add_point(Vector2(0, screen_size.y))
	# Set 5th vector
	$MobPath.curve.add_point(Vector2(0, 0))
	
	# Clear all Vector2 points
	$PowerUpPath.curve.clear_points()
	$PowerUpPath.curve.add_point(Vector2(10, 0))
	$PowerUpPath.curve.add_point(Vector2(screen_size.x-10,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$PowerUpTimer.stop()
	$Player/AnimatedSprite2D.animation = "death"
	$HUD/PowerUpLabel.text = ""
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerup", "queue_free")
	await get_tree().create_timer(1.0).timeout
	$HUD.show_game_over(score)
	
func on_shield():
	$HUD/PowerUpLabel.text = "Shield is UP!"
	await get_tree().create_timer(5.0).timeout
	$HUD/PowerUpLabel.text = ""
	
func on_time():
	$HUD/PowerUpLabel.text = "Mobs spawn is slowed!"
	$MobTimer.wait_time = 1.5
	await get_tree().create_timer(6.0).timeout
	$MobTimer.wait_time = 0.8
	$HUD/PowerUpLabel.text = ""
	
func on_fast():
	$HUD/PowerUpLabel.text = "Speed is UP!"
	await get_tree().create_timer(6.0).timeout
	$HUD/PowerUpLabel.text = ""
	
func new_game():
	var screen_size = get_viewport().get_visible_rect().size
	score = 0
	$StartPosition.global_position = (Vector2(screen_size.x / 2, screen_size.y / 2))
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	
func pause_game():
	if $HUD.pause_state == true:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_mob_timer_timeout():
	# Creazione dell'istanza di un nuovo Mob
	var mob = mob_scene.instantiate()
	
	# Scegliamo un punto randomico su Path2
	var mob_spawn_location = $MobPath / MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Settiamo la direzione del mob perpendicolare alla direzione scelta dall path
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Settiamo randomicamente la posizione del mob
	mob.position = mob_spawn_location.position
	
	# Aggiungiamo un poco di randomicità alla direzione
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Scegliamo la velocità del mob
	var velocity = Vector2(randf_range(175.0, 350.0), 0.0)
	velocity.x += (score*20) / 90
	
	mob.linear_velocity = velocity.rotated(direction)
	
	# Adesso possiamo far spawnare il mob nella scena principale
	add_child(mob)
	
func _on_power_up_timer_timeout():
		# Creazione dell'istanza di un nuovo Mob
	var powerup = powerup_scene.instantiate()
	
	# Scegliamo un punto randomico su Path2
	var power_up_location = $PowerUpPath / PowerUpSpawnLocation
	power_up_location.progress_ratio = randf()
	
	# Settiamo la direzione del mob perpendicolare alla direzione scelta dall path
	var direction = power_up_location.rotation + PI / 2
	
	# Settiamo randomicamente la posizione del mob
	powerup.position = power_up_location.position
	
	# Scegliamo la velocità del mob
	var velocity = Vector2(randf_range(175.0, 350.0), 0.0)
	
	powerup.linear_velocity = velocity.rotated(direction)
	
	# Adesso possiamo far spawnare il mob nella scena principale
	add_child(powerup)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$PowerUpTimer.start()
	$ScoreTimer.start()
