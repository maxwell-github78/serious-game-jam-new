extends Node2D
class_name Trail

var start_position: Vector2
var end_position: Vector2
var tween := create_tween()

func _init(start: Vector2, end: Vector2) -> void:
	start_position = start
	end_position = end
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.5)
	tween.finished.connect(queue_free)
	

func _draw():
	draw_line(start_position, end_position, Color.AZURE, 1.0, true)
