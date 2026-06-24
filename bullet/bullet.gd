extends Area2D
class_name Bullet

var velocity: Vector2
var n: int
var damage: int = 10
var spin: bool
var knockback: float

@onready var sprite := $Sprite2D

func _ready() -> void:
	body_entered.connect(collision)
	if sprite is AnimatedSprite2D:
		sprite.play("default")


func _process(delta: float) -> void:
	if spin:
		sprite.rotate(PI/8 * 60 * delta)

func _physics_process(delta: float) -> void:
	if n > 0:
		position += velocity * delta
	else:
		n += 1
	
func collision(body: Node2D) -> void:
	#print("hit projectile: ", body)
	for child in body.get_children():
		if child is HealthComponent:
			body.velocity = velocity.normalized() * knockback
			child.take_damage(damage)
	
	queue_free()
