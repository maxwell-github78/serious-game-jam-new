extends Control

@onready var head: UIHead = $".."
var max_rounds: int = 6
var ammo_array: Array[TextureRect]
@export var ammo_texture: Texture2D

func _ready() -> void:
	for i in range(max_rounds):
		var ammo_icon := TextureRect.new()
		ammo_icon.texture = ammo_texture
		ammo_icon.position = Vector2(i * 32.0, 0)
		ammo_array.append(ammo_icon)
		add_child(ammo_icon)
		
func setup_signal() -> void:
	head.game.player.gun.rounds_changed.connect(update_ui)

func update_ui(rounds: int) -> void:
	var i := 0
	for icon in ammo_array:
		if rounds == 0:
			icon.modulate = Color.RED
		else:
			if i >= rounds:
				icon.modulate = Color.DIM_GRAY
			else:
				icon.modulate = Color.WHITE
			i += 1
	
