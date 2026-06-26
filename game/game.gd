extends Node2D
class_name Game

@onready var projectiles: Node2D = $Projectiles
@onready var player: Player = $Player
@onready var enemies: Node2D = $Enemies
@onready var room: Node2D = $Room
@onready var walls: TileMapLayer = $Room/Tilemap/Walls
@onready var floors: TileMapLayer = $Room/Tilemap/Floor
@onready var start_marker: Node2D = $Room/Tilemap/PlayerSpawn
@onready var player_leave: Area2D = $Room/Tilemap/PlayerLeave

@export_category("Difficulty Scaling")
@export var starting_value: int = 40
@export var increase_by: int = 30
@export var chance_for_elite: float = 0.1
@export var rooms_to_beat: int = 15

var current_balance_value := starting_value

var valid_tiles_dict: Dictionary[Vector2i, bool] = {}
var valid_tiles: Array[Vector2i]
var previous_room: PackedScene

var enemy_pool: Array[PackedScene]
var enemy_positions_pool: Array[Vector2]
var enemy_elite_pool: Array[bool]
var enemy_balance_values: Dictionary[PackedScene, int]
var spawned_enemies: int = 0

var enemy_scenes: Array = Files.read_scenes("res://enemy/enemies").values()
var room_scenes: Array = Files.read_scenes("res://tilemap/rooms").values()

var resetting: bool

var rooms_cleared: int = 0:
	set(new_value):
		rooms_cleared = new_value
		if new_value == rooms_to_beat:
			game_won.emit()
			get_tree().change_scene_to_file("res://main_menu.tscn")


@export var SCENE_OVERRIDE: PackedScene

signal room_cleared
signal game_over
signal game_won

var picking_substance: bool = false:
	set(new_value):
		picking_substance = new_value
		if new_value: 
			for child in projectiles.get_children():
				child.queue_free()

var remaining_enemies: int:
	set(new_value):
		remaining_enemies = new_value
		if new_value == 0 and not resetting:
			room_cleared.emit()
			
func new_room() -> void:
	rooms_cleared += 1
	print(rooms_cleared)
	room.get_child(0).free()
	var new_room_scene: Node2D 
	if SCENE_OVERRIDE != null:
		new_room_scene = SCENE_OVERRIDE.instantiate()
	else:
		var valid_room_scenes = room_scenes.duplicate_deep()
		valid_room_scenes.erase(previous_room)
		var packed_scene: PackedScene = valid_room_scenes.pick_random()
		previous_room = packed_scene
		new_room_scene = packed_scene.instantiate()
	room.add_child(new_room_scene)
	room = get_child(0)
	walls = room.get_child(0).get_child(2)
	floors = room.get_child(0).get_child(0)
	start_marker = room.get_child(0).get_child(3)
	player_leave = room.get_child(0).get_child(4)
	player.position = start_marker.global_position
	_spawn_enemies(current_balance_value)
	
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
	StatChanges.init(self)
	
	
	for key in enemy_scenes:
		var enemy: Enemy = key.instantiate()
		enemy_balance_values[key] = enemy.balance_value
		enemy.free()
	
	const bottle_guy: PackedScene = preload("res://enemy/enemies/bottle-guy.tscn") #Stupid way to pad the odds
	for i in range(2):
		enemy_scenes.append(bottle_guy)
	
	current_balance_value = starting_value	
	
	
	new_room()
	

func _spawn_enemies(value: int) -> void:
	var multiplied_value = value * StatChanges.get_multiplier(StatChanges.multiplier_keys.ENEMY_SPAWN_RATE)
	for child in enemies.get_children():
		child.queue_free()
	#Find valid tiles
	valid_tiles_dict.clear()
	valid_tiles.clear()
	for tile in floors.get_used_cells():
		if tile != Vector2i(-1, -1):
			valid_tiles_dict[tile] = true
		else:
			valid_tiles_dict[tile] = false
	for tile in walls.get_used_cells():
		if valid_tiles_dict.has(tile):
			valid_tiles_dict[tile] = false
	for tile in valid_tiles_dict.keys():
		if valid_tiles_dict[tile]:
			valid_tiles.append(tile)
			
	for tile in valid_tiles:
		if floors.local_to_map(tile*32.0) == Vector2i(-1, -1):
			print("Spawning enemies on invalid tile")
	
	var balance: int = 0
	var n: int = 0
	while balance < multiplied_value and n < 15:
		var grid_position: Vector2i = valid_tiles.pick_random()
		valid_tiles.erase(grid_position)
		var spawn_position := Vector2(grid_position) * 32.0 
		
		var offset: Vector2 = spawn_position - player.position
		if offset.length() < 32.0 * 8:
			continue
		var enemy_pckd_scene = enemy_scenes.pick_random()
		#var enemy: Enemy = enemy_pckd_scene.instantiate()
		balance += enemy_balance_values[enemy_pckd_scene]
		var is_elite: bool = randf() < chance_for_elite * StatChanges.get_multiplier(StatChanges.multiplier_keys.ENEMY_SPAWN_RATE)
		enemy_pool.append(enemy_pckd_scene)
		enemy_positions_pool.append(spawn_position)
		enemy_elite_pool.append(is_elite)
		n += 1
	current_balance_value += increase_by
	remaining_enemies = n
	

func reset() -> void:
	game_over.emit()
	$Music.play(0.0)
	resetting = true
	rooms_cleared = 0
	for child in enemies.get_children() + projectiles.get_children():
		child.queue_free()
	current_balance_value = starting_value
	player.health_component.max_health = player.starting_health
	player.health_component.health = player.starting_health
	StatChanges.init(self)
	new_room()
	resetting = false

func _process(_delta: float) -> void:
	if enemy_pool and spawned_enemies < 10:
		var spawn_position: Vector2 = enemy_positions_pool.pop_front()
		var enemy: Enemy = enemy_pool.pop_front().instantiate()
		enemy.position = spawn_position
		enemy.elite = enemy_elite_pool.pop_front()
		enemies.add_child(enemy)
		spawned_enemies += 1
	
	if Input.is_action_just_pressed("ui_accept"):
		for enemy in enemies.get_children():
			enemy.queue_free()
		remaining_enemies = 0
		
	
		
			
