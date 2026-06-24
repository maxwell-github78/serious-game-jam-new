extends Button
class_name SubstanceButton

var substance: Substance
signal chosen_substance(chosen: Substance)

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	chosen_substance.emit(substance)
