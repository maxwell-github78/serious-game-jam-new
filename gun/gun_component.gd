extends Node2D
class_name GunComponent

var parent: Node2D

@export_category("Shooting")
@export var bullet_speed = 1600.0
@export var gun_capacity = 6
@export var reload_wait_time = 2
@export var shoot_interval_time = 0.5
@export var gun_knockback_acceleration = 100.0

var rounds = gun_capacity
var reload_timer := Timer.new()
var shoot_timer := Timer.new()

const packed_bullet: PackedScene = preload("res://bullet/bullet.tscn")


func _init() -> void:
	reload_timer.one_shot = true
	reload_timer.wait_time = reload_wait_time
	reload_timer.timeout.connect(reload)
	add_child(reload_timer)
	
	shoot_timer.one_shot = false
	shoot_timer.wait_time = shoot_interval_time
	shoot_timer.timeout.connect(shoot)
	add_child(shoot_timer)

func shoot() -> void:
	if rounds > 0:
		rounds -= 1
		var bullet: Bullet = packed_bullet.instantiate()
		var shoot_direction := get_global_mouse_position() - parent.position
		shoot_direction = shoot_direction.normalized()
		bullet.position = parent.bullet_start.global_position
		bullet.rotation = parent.rotation
		bullet.velocity = shoot_direction * bullet_speed
		bullet.walls = parent.game.walls
		parent.game.projectiles.add_child(bullet)
		parent.velocity += -shoot_direction * gun_knockback_acceleration
	else:
		print("out of ammo")

func reload() -> void:
	print("reloaded")
	rounds = gun_capacity
	if not shoot_timer.is_stopped(): #shoots immediately if held down
		shoot()
		shoot_timer.start()
