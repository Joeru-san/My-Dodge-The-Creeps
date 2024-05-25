extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size  =  get_viewport().get_visible_rect().size
	$TextureRect.global_position = Vector2(screen_size.x / 2 - 85, screen_size.y - 220)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
