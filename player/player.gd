extends CharacterBody2D

@export_category("Movement")
@export var acceleration = 80.0
@export var max_speed = 200.0
@export var friction = 0.2

@export_category("Combat")
@export var starting_health: int = 100

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

var running = false

func _ready():
	add_child(gun)
	add_child(health_component)
	gun.parent = self
	gun.gun_capacity = gun_capacity
	gun.reload_wait_time = reload_wait_time
	gun.shoot_interval_time = shoot_interval_time
	gun.gun_knockback_acceleration = gun_knockback_acceleration
	
func _physics_process(delta: float) -> void:
	var direction: Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	running = false
	if direction.x:
		velocity.x += direction.x * acceleration
		running = true
		
	if direction.y:
		velocity.y += direction.y * acceleration
		running = true
		
	if running:
		upper.play("running")
		lower.play("running")
	else:
		upper.stop()
		lower.stop()
		
	velocity -= friction * velocity


	clamp(velocity.x, -max_speed, max_speed)
	clamp(velocity.y, -max_speed, max_speed)

	move_and_slide()

func _process(_delta: float) -> void:
	_look_at_mouse()
	
	if gun.rounds == 0 and gun.reload_timer.is_stopped():
		print("reloading")
		gun.reload_timer.start()		

	if Input.is_action_just_pressed("ui_shoot"):
		gun.shoot_timer.start()
		gun.shoot()
	if Input.is_action_just_released("ui_shoot"):
		gun.shoot_timer.stop()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	
func _look_at_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

func death() -> void: 
	print("player dead")
		


		
