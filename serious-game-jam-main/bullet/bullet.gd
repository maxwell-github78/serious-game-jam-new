extends Area2D
class_name Bullet

var velocity: Vector2
var walls: TileMapLayer
var n: int

func _ready() -> void:
	body_entered.connect(collision)

func _physics_process(delta: float) -> void:
	if n > 0:
		position += velocity * delta
	else:
		n += 1
	
func collision(body: Node2D) -> void:
	print(body)
	queue_free()
