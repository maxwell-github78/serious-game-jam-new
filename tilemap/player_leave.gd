extends Area2D

@onready var game: Game = $"../../.."
@onready var player: CharacterBody2D = game.player
var player_inside: bool = false

func _ready() -> void:
	body_entered.connect(_check_if_player_inside)
	body_exited.connect(_check_if_player_not_inside)

func _process(_delta: float) -> void:
	if game.remaining_enemies == 0 and player_inside:
		player_inside = false
		var rect := ColorRect.new()
		rect.color = Color(0, 0, 0, 0)
		rect.size = Vector2(1280 * 4, 720 * 4)
		rect.position = position - Vector2(1280 * 2, 720 * 2)
		game.add_child(rect)
		var tween := create_tween()
		tween.tween_property(rect, "color:a", 1, 0.5)
		tween.finished.connect(game.new_room)
		tween.finished.connect(rect.queue_free)



func _check_if_player_inside(body) -> void: 
	if body == game.player:
		player_inside = true

func _check_if_player_not_inside(body) -> void: 
	if body == game.player:
		player_inside = false
