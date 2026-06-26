extends Node
class_name HealthComponent

var max_health: float
var health: float
var parent: CharacterBody2D

func _init(starting_health: int) -> void:
	max_health = starting_health
	health = starting_health
	

func take_damage(amount: float) -> void:
	parent = get_parent()
	health -= amount
	health = clamp(health, 0, max_health)
	if health <= 0:
		print("killed")
		parent.death()
