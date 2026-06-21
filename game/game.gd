extends Node2D
class_name Game

@onready var projectiles: Node2D = $Projectiles
@onready var walls: TileMapLayer = $Tilemap/Walls
@onready var floors: TileMapLayer = $Tilemap/Floor
@onready var player: CharacterBody2D = $Player
@onready var enemies: Node2D = $Enemies

var valid_tiles_dict: Dictionary[Vector2i, bool] = {}
var valid_tiles: Array[Vector2i]

const enemy_pckd_scene: PackedScene = preload("res://enemy/enemy.tscn")

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
	
	var i: int = 0
	while i < n:
		var grid_position = valid_tiles.pick_random()
		valid_tiles.erase(grid_position)
		var spawn_position := Vector2(grid_position) * 32.0 
		
		var offset: Vector2 = spawn_position - player.position
		if offset.length() < 32.0 * 4:
			continue
		
		i += 1
		var enemy: CharacterBody2D = enemy_pckd_scene.instantiate()
		enemy.position = spawn_position
		enemies.add_child(enemy)
		
	
			
