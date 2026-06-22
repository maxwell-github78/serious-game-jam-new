extends Node2D
class_name Game

@onready var projectiles: Node2D = $Projectiles
@onready var player: CharacterBody2D = $Player
@onready var enemies: Node2D = $Enemies
@onready var room: Node2D = $Room
@onready var walls: TileMapLayer = $Room/Tilemap/Walls
@onready var floors: TileMapLayer = $Room/Tilemap/Floor
@onready var start_marker: Node2D = $Room/Tilemap/PlayerSpawn

var valid_tiles_dict: Dictionary[Vector2i, bool] = {}
var valid_tiles: Array[Vector2i]

const enemy_pckd_scene: PackedScene = preload("res://enemy/enemy.tscn")
var room_scenes: Array = Files.read_scenes("res://tilemap/rooms").values()

@export var SCENE_OVERRIDE: PackedScene

var remaining_enemies: int
			
func new_room() -> void:
	room.get_children()[0].queue_free()
	var new_room_scene: Node2D 
	if SCENE_OVERRIDE != null:
		new_room_scene = SCENE_OVERRIDE.instantiate()
	else:
		var packed_scene: PackedScene = room_scenes.pick_random()
		new_room_scene = packed_scene.instantiate()
	room.add_child(new_room_scene)
	room = $Room
	walls = $Room/Tilemap/Walls
	floors = $Room/Tilemap/Floor
	start_marker = $Room/Tilemap/PlayerSpawn
	player.position = start_marker.global_position
	_spawn_enemies(8)
	
	var rect := ColorRect.new()
	rect.color = Color(0, 0, 0, 1)
	rect.size = Vector2(1280 * 4, 720 * 4)
	rect.position = position - Vector2(1280 * 2, 720 * 2)
	add_child(rect)
	var tween := create_tween()
	tween.tween_property(rect, "color:a", 0, 0.5)
	tween.finished.connect(rect.queue_free)
	

func _ready() -> void:
	Engine.max_fps = 60
	new_room()

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
	
	remaining_enemies = n
		
			
