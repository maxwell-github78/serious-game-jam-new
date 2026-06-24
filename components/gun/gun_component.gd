extends Node2D
class_name GunComponent

var parent: Node2D

var gun_capacity = 6
var reload_wait_time = 2
var shoot_interval_time = 0.5
var gun_knockback_acceleration = 300.0

signal rounds_changed(value: int)
var rounds: int: 
	set(new_value):
		rounds = new_value
		rounds_changed.emit(new_value)

		
var reload_timer := Timer.new()
var shoot_timer := Timer.new()

var infinite_ammo := false

func _ready() -> void:
	rounds = gun_capacity

func _init() -> void:
	reload_timer.one_shot = true
	reload_timer.wait_time = reload_wait_time
	reload_timer.timeout.connect(reload)
	add_child(reload_timer)
	
	shoot_timer.one_shot = false
	shoot_timer.wait_time = shoot_interval_time
	shoot_timer.timeout.connect(shoot)
	add_child(shoot_timer)

func reload() -> void:
	print("reloaded")
	rounds = gun_capacity
	if not shoot_timer.is_stopped(): #shoots immediately if held down
		shoot()
		shoot_timer.start()

func shoot() -> void:
	return
