extends CanvasLayer
class_name UIHead

@onready var game = $"../Game"
@onready var ammo = $Ammo

func _ready() -> void:
	ammo.setup_signal()
