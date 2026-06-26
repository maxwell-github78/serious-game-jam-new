extends TextureRect
@onready var ui: UIHead = $".."

const over_texture: Texture2D = preload("res://assets/textures/screens/Losing screen .png")

signal any_input

func setup_signal() -> void:
	ui.game.game_over.connect(_on_game_over)
	ui.game.game_won.connect(_on_game_won)

func _on_game_over() -> void:
	texture = over_texture
	splash()

func _on_game_won() -> void:
	texture = over_texture
	splash()

func splash() -> void:
	visible = true
	get_tree().paused = true
	var timer := Timer.new()
	add_child(timer)
	timer.start(0.5)
	await timer.timeout
	await any_input
	get_tree().paused = false
	visible = false

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		any_input.emit()
	
