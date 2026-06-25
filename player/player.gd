extends CharacterBody2D
class_name Player
@export_category("Movement")
@export var acceleration = 80.0
@export var max_speed: float = 200.0
@export var friction = 0.2

@export_category("Combat")
@export var starting_health: int = 100
@export var damage: int = 10

@export_category("Shooting")
@export var gun_capacity = 6
@export var reload_wait_time = 2
@export var shoot_interval_time = 0.5
@export var gun_knockback_acceleration = 100.0

@onready var game: Game = get_parent()
@onready var bullet_start = $"Bullet Start"
@onready var gun = HitscanComponent.new()
@onready var health_component = HealthComponent.new(starting_health)

@onready var lower: AnimatedSprite2D = $LowerBody
@onready var upper: AnimatedSprite2D = $UpperBody

var dodge_chance: float = 0.0:
	set(new_value):
		dodge_chance = clamp(new_value, 0.0, 0.8)
		

var running = false

func _ready():
	add_child(gun)
	add_child(health_component)
	gun.parent = self
	gun.gun_capacity = gun_capacity
	gun.reload_wait_time = reload_wait_time
	gun.shoot_interval_time = shoot_interval_time
	gun.gun_knockback_acceleration = gun_knockback_acceleration
	
	
func _physics_process(_delta: float) -> void:
	var direction: Vector2
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	running = false
	if direction:
		velocity += direction * acceleration * StatChanges.get_multiplier(StatChanges.multiplier_keys.PLAYER_MOVESPEED)
		running = true
		
	if running and not game.picking_substance:
		upper.play("running")
		lower.play("running")
	else:
		upper.stop()
		lower.stop()
		
	velocity -= friction * velocity

	var multiplied_max_speed: float = max_speed * StatChanges.get_multiplier(StatChanges.multiplier_keys.PLAYER_MOVESPEED)
	#print(multiplied_max_speed, " : ", max_speed)
	clamp(velocity.x, -multiplied_max_speed, multiplied_max_speed)
	clamp(velocity.y, -multiplied_max_speed, multiplied_max_speed)
	if not game.picking_substance:
		move_and_slide()

func _process(_delta: float) -> void:
	_look_at_mouse()
	
	if gun.rounds == 0 and gun.reload_timer.is_stopped() and not game.picking_substance:
		print("reloading")
		gun.reload_timer.start()		
	
	if not game.picking_substance: 
		if Input.is_action_just_pressed("ui_shoot"):
			gun.shoot_timer.start()
			gun.shoot()
		if Input.is_action_just_released("ui_shoot"):
			gun.shoot_timer.stop()
	else:
		gun.shoot_timer.stop()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	
func _look_at_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

func death() -> void: 
	print("player dead")
	game.reset()
		


		
