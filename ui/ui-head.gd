extends CanvasLayer
class_name UIHead

@onready var game: Game = $"../Game"
@onready var ammo = $Ammo
@onready var pick_substance = $PickSubstance

func _ready() -> void:
	ammo.setup_signal()
	pick_substance.setup_signal()
