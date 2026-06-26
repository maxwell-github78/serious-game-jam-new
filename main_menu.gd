extends Control

@onready var play_button: TextureButton = $Buttons/Play
@onready var options_button: TextureButton = $Buttons/Options
@onready var pause: Pause = $Pause

func _ready() -> void:
	play_button.pressed.connect(_on_play)
	options_button.pressed.connect(_on_options)
	pause.read_input = false
	for button in $Buttons.get_children():
		button.mouse_entered.connect(
			func(): button.modulate = Color(0.7, 0.7, 0.7)
		)
		button.mouse_exited.connect(
			func(): button.modulate = Color(1, 1, 1)
		)
	
func _on_play() -> void:
	pause.paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://loading.tscn")

func _on_options() -> void:
	pause.on_pause_changed(true)
	
