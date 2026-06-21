extends AnimatedSprite2D

func _ready() -> void:
	play("default")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(_delta: float) -> void:
	position = get_global_mouse_position()
