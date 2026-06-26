extends Control

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var head: UIHead = $".."

func _process(_delta: float) -> void:
	bar.max_value = head.game.player.health_component.max_health
	bar.value = head.game.player.health_component.health
	#print(head.game.player.health_component.health)
