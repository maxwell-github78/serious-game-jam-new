extends CharacterBody2D

@export_category("Movement")
@export var acceleration = 80.0
@export var max_speed = 200.0
@export var friction = 0.2

@onready var game: Game = get_parent()
@onready var bullet_start = $"Bullet Start"
@onready var gun = GunComponent.new()

func _ready():
	add_child(gun)
	gun.parent = self
	
func _physics_process(_delta: float) -> void:
	var direction: Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction.x:
		velocity.x += direction.x * acceleration
		
	if direction.y:
		velocity.y += direction.y * acceleration
		
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

	
func _look_at_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
		


		
