extends Area2D
class_name Bullet

var velocity: Vector2
var n: int
var damage: int = 10
var spin: bool

@onready var sprite := $Sprite2D

var texture: Texture2D:
	set(new_texture):
		sprite.texture = new_texture

func _process(delta: float) -> void:
	if spin:
		sprite.rotate(PI/8 * 60 * delta)

func _ready() -> void:
	body_entered.connect(collision)

func _physics_process(delta: float) -> void:
	if n > 0:
		position += velocity * delta
	else:
		n += 1
	
func collision(body: Node2D) -> void:
	print("hit projectile: ", body)
	for child in body.get_children():
		if child is HealthComponent:
			child.take_damage(damage)
	
	queue_free()
