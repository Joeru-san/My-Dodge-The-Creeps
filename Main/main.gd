extends Node

@export var mob_scene: PackedScene
@export var powerup_scene: PackedScene

var music_tracks = [
	"res://art/music/music_fx_battle_music_1.wav",
	"res://art/music/music_fx_battle_music_2.wav",
	"res://art/music/music_fx_battle_music_3.wav",
	"res://art/music/music_fx_battle_music_4.wav"
]

var score

var popup_panel

func _set_pillar_tiles(x, y):
	var tiles = [
		Vector2i(22, 10), Vector2i(22, 11), Vector2i(22, 12), Vector2i(22, 13), Vector2i(22, 14), Vector2i(22, 15),
		Vector2i(23, 10), Vector2i(23, 11), Vector2i(23, 12), Vector2i(23, 13), Vector2i(23, 14), Vector2i(23, 15)
	]
	var tiles_offset = [0, 1, 2, 3, 4, 5]
	
	for offset in tiles_offset:
		$TileMap.set_cell(2, Vector2i(x, y + offset), 1, tiles[offset])
		$TileMap.set_cell(2, Vector2i(x + 1, y + offset), 1, tiles[offset + 6])
		
	var overlay_tiles = [
		Vector2i(22, 12), Vector2i(22, 13), Vector2i(22, 14), Vector2i(22, 15),
		Vector2i(23, 12), Vector2i(23, 13), Vector2i(23, 14), Vector2i(23, 15),
		Vector2i(24, 12), Vector2i(24, 13), Vector2i(24, 14), Vector2i(24, 15)
	]
	
	for offset in range(3, 7):
		$TileMap.set_cell(0, Vector2i(x, y + offset-1), 3, overlay_tiles[offset - 3])
		$TileMap.set_cell(0, Vector2i(x + 1, y + offset-1), 3, overlay_tiles[offset + 1])
		$TileMap.set_cell(0, Vector2i(x + 2, y + offset-1), 3, overlay_tiles[offset + 5])

func _drawing_pillars_left(y_cells):
	for i in range(0, y_cells.size(), 6):
		_set_pillar_tiles(1, 3 + i)

func _drawing_pillars_right(y_cells, no_of_x_cells):
	for i in range(0, y_cells.size(), 6):
		_set_pillar_tiles(no_of_x_cells - 3, 3 + i)

func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	$MobPath.curve.clear_points()
	$MobPath.curve.add_point(Vector2(70, 70))
	$MobPath.curve.add_point(Vector2(screen_size.x - 30, 30))
	$MobPath.curve.add_point(Vector2(screen_size.x - 30, screen_size.y - 30))
	$MobPath.curve.add_point(Vector2(20, screen_size.y - 30))
	$MobPath.curve.add_point(Vector2(40, 40))
	
	$PowerUpPath.curve.clear_points()
	$PowerUpPath.curve.add_point(Vector2(10, 0))
	$PowerUpPath.curve.add_point(Vector2(screen_size.x - 10, 0))
	
	var no_of_y_cells = ceil(screen_size.y / $TileMap.tile_set.tile_size.y)
	var y_cells = range(0, no_of_y_cells)
	var no_of_x_cells = ceil(screen_size.x / $TileMap.tile_set.tile_size.x)
	
	_drawing_pillars_left(y_cells)
	if OS.has_feature("web_linuxbsd") or OS.has_feature("web_macos") or OS.has_feature("web_windows"):
		no_of_x_cells-=1
	_drawing_pillars_right(y_cells, no_of_x_cells)
	
	var random_index = randi() % music_tracks.size()
	var selected_track = music_tracks[random_index]
	
	$Music.stream = load(selected_track)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		$HUD/PopupDialog.show()
	
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
	$MobTimer.wait_time = max(0.1, 0.6 - (score / 10) * 0.03)
	
	var mob = mob_scene.instantiate()
	
	mob.velocity.x += (score * 30) / 90
	
	var mob_spawn_location = $MobPath / MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	print($MobTimer.wait_time)

	mob.position = mob_spawn_location.position
	add_child(mob)


func _on_power_up_timer_timeout():
	var powerup = powerup_scene.instantiate()
	
	var power_up_location = $PowerUpPath / PowerUpSpawnLocation
	power_up_location.progress_ratio = randf()
	
	var direction = power_up_location.rotation + PI / 2
	
	powerup.position = power_up_location.position
	
	var velocity = Vector2(randf_range(175.0, 350.0), 0.0)
	
	powerup.linear_velocity = velocity.rotated(direction)
	
	add_child(powerup)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$PowerUpTimer.start()
	$ScoreTimer.start()
