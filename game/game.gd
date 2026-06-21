extends Node2D
class_name Game

@onready var projectiles: Node2D = $Projectiles
@onready var walls: TileMapLayer = $Tilemap/Walls
@onready var floors: TileMapLayer = $Tilemap/Floor

var valid_tiles_dict: Dictionary[Vector2i, bool] = {}
var valid_tiles: Array[Vector2i]

func _ready() -> void:
	Engine.max_fps = 60
	
	_spawn_enemies(4)

func _spawn_enemies(n: int) -> void:
	
	#Find valid tiles
	for tile in floors.get_used_cells():
		valid_tiles_dict[tile] = true
	for tile in walls.get_used_cells():
		if valid_tiles_dict.has(tile):
			valid_tiles_dict[tile] = false
	for tile in valid_tiles_dict.keys():
		if valid_tiles_dict[tile]:
			valid_tiles.append(tile)
	
	var debug_sprite := load("res://assets/textures/debug_marker.png")
	for i in range(n):
		var grid_position = valid_tiles.pick_random()
		valid_tiles.erase(grid_position)
		var debug := Sprite2D.new()
		debug.position = Vector2(grid_position) * 32.0 
		debug.texture = debug_sprite
		add_child(debug)
		
	
			
