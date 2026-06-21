extends Area2D
class_name Bullet

var velocity: Vector2
var walls: TileMapLayer
var n: int

@onready var sprite := $Sprite2D

var texture: Texture2D:
	set(new_texture):
		sprite.texture = new_texture

func _process(delta: float) -> void:
	sprite.rotate(PI/8 * 60 * delta)

func _ready() -> void:
	body_entered.connect(collision)

func _physics_process(delta: float) -> void:
	if n > 0:
		position += velocity * delta
	else:
		n += 1
	
func collision(body: Node2D) -> void:
	#print(body)
	
	queue_free()
