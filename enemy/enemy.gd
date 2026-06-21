extends CharacterBody2D


@export_category("Movement")
@export var acceleration = 50.0
@export var max_speed = 150.0
@export var friction = 0.2

@onready var game: Game = get_parent().get_parent()
@onready var bullet_start = $"Bullet Start"
@onready var gun = HitscanComponent.new()

@onready var lower: AnimatedSprite2D = $LowerBody
@onready var upper: AnimatedSprite2D = $UpperBody

var running = false


func _physics_process(delta: float) -> void:
	return
