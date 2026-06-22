extends Node
class_name HealthComponent

var max_health: int
var health: int
var parent: CharacterBody2D

func _init(starting_health: int) -> void:
	max_health = starting_health
	health = starting_health
	

func take_damage(amount: int) -> void:
	parent = get_parent()
	health -= amount
	clamp(health, 0, max_health)
	if health <= 0:
		print("killed")
		parent.death()
