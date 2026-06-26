extends CharacterBody2D
class_name Enemy

@export_category("Movement")
@export var acceleration = 20.0
@export var max_speed = 80.0
@export var friction = 0.2
@export var random_offset = 32.0

@export_category("Shooting")
@export var bullet_speed = 200.0
@export var throw_time = 3.0
@export var throw_time_randomness = 2.0
@export var gun_knockback_acceleration = 100.0
@export var projectile_spin: bool = true
@export var projectile_scene: PackedScene

@export_category("Combat")
@export var damage: int = 10
@export var starting_health: int = 20
@export var balance_value: int = 10

@onready var game: Game = get_parent().get_parent()
@onready var tilemap
@onready var bullet_start = $"Bullet Start"
@onready var gun = HitscanComponent.new()
@onready var health_component = HealthComponent.new(starting_health)

@onready var body: AnimatedSprite2D = $Body
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

var projectiles := ProjectileComponent.new()

var throw_timer := Timer.new()

var throwing = false
var thrown = false
var spotted_player = false
var prev_delta: float
var previous_position: Vector2 = position
var offset: Vector2

func _ready() -> void:
	rotation = randf() * 2 * PI
	add_child(health_component)
	
	player = game.player
	
	navigation.velocity_computed.connect(_move)
	offset = Vector2(randf_range(-random_offset, random_offset), randf_range(-random_offset, random_offset))
	
	throw_timer.one_shot = true
	throw_timer.timeout.connect(_set_throwing)
	add_child(throw_timer)
	
	projectiles.parent = self
	projectiles.infinite_ammo = true
	projectiles.spin = projectile_spin
	projectiles.bullet_speed = bullet_speed
	projectiles.packed_bullet = projectile_scene
	body.animation_finished.connect(_end_throwing)

func throw() -> void:
	projectiles.shoot()
	thrown = true
	
func _end_throwing() -> void:
	throwing = false
	thrown = false


func _set_throwing() -> void:
	throwing = true
	
func _process(_delta: float) -> void:
	if spotted_player:
		look_at(player.position)
	if body.animation == "throwing" and body.frame == 3 and not thrown:
		throw()

func death() -> void: 
	game.player.health_component.take_damage(-balance_value)
	game.remaining_enemies -= 1
	queue_free()
	
func _physics_process(delta: float) -> void:
	prev_delta = delta
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, player.position, 1)
	var result := space_state.intersect_ray(query)
	
	if game.floors:
		if not game.floors.local_to_map(global_position) in game.floors.get_used_cells():
			print("died to being out of bounds")
			death()

	if result and result.collider == player:
		spotted_player = true
		
	if spotted_player and not throwing:
		if throw_timer.is_stopped():
			var multiplied_throw_time = ( throw_time + randf_range(-throw_time_randomness, throw_time_randomness) ) * StatChanges.get_multiplier(StatChanges.multiplier_keys.ENEMY_FIRE_WAIT_TIME)
			throw_timer.start(multiplied_throw_time)
		navigation.target_position = player.position + offset
		
		var next := navigation.get_next_path_position()
		var difference := navigation.target_position - position
		
		if difference.length() > 64.0:
			
			var path_direction: Vector2 = next - position
			path_direction = path_direction.normalized()

			velocity += path_direction * acceleration * StatChanges.get_multiplier(StatChanges.multiplier_keys.ENEMY_MOVESPEED)
			
			var multiplied_max_speed: float = max_speed * StatChanges.get_multiplier(StatChanges.multiplier_keys.ENEMY_MOVESPEED)
			clamp(velocity.x, -multiplied_max_speed, multiplied_max_speed)
			clamp(velocity.y, -multiplied_max_speed, multiplied_max_speed)
			
		else:
			_stop()
	elif throwing:
		body.play("throwing")
	else:
		_stop()
	velocity -= friction * velocity 
		
	if navigation.avoidance_enabled:
		navigation.velocity = velocity
	else:
		_move(velocity)

func _move(safe_velocity: Vector2) -> void:
	move_and_collide(safe_velocity * prev_delta)
	var difference: Vector2 = position - previous_position
	if not throwing:
		if difference.length() > 24.0 / 60.0:
			body.play("running")
		else:
			body.play("default")
	previous_position = position

func _stop() -> void:
	body.stop()
	#velocity = Vector2.ZERO
