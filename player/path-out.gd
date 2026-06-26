extends Node2D

var player: CharacterBody2D
var out: Area2D

func _draw() -> void:
	draw_line(player.position, out.shape.position, Color(0.3, 0.8, 0.8, 0.95), 3.0)
