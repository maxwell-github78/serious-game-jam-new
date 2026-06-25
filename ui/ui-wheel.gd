extends TextureRect
class_name Wheel

var starting_velocity: float
var velocity: float
var friction: float
var angle: float = 0.0
var textures: Array

signal finished_spinning(dosage: float)

const dosages: Array[float] = [1.0, 2.0, 4.0, 0.5]

func _ready() -> void:
	starting_velocity = randf_range(PI * 0.4, PI * 0.4)
	friction = randf_range(0.01, 0.015)
	velocity = starting_velocity
	size = Vector2(64, 64)
	
func _physics_process(_delta: float) -> void:
	velocity -= friction * velocity
	angle += velocity
	var modulo: float = modf(angle, PI*2)
	#print(angle, " : ", modulo)
	var quadrant: int = floor(modulo / (PI/2))
	#print(quadrant)
	texture = textures[quadrant]
	if velocity < 0.1 and velocity != 0.0:
		velocity = 0.0
		finished_spinning.emit(dosages[quadrant])
		
	
static func modf(a: float, b: float) -> float:
	var remainder: float = a
	while remainder > b:
		remainder -= b
	return remainder
