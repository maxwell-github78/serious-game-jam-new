extends GunComponent
class_name ProjectileComponent

@export_category("Shooting")
@export var bullet_speed = 200.0

const packed_bullet: PackedScene = preload("res://bullet/bullet.tscn")
var texture: Texture2D

func shoot() -> void:
	if rounds > 0 or infinite_ammo:
		rounds -= 1
		var bullet: Bullet = packed_bullet.instantiate()
		parent.game.projectiles.add_child(bullet)
		bullet.texture = texture
		var shoot_rotation := parent.rotation
		var shoot_direction = Vector2(cos(shoot_rotation), sin(shoot_rotation))
		shoot_direction = shoot_direction.normalized()
		bullet.position = parent.bullet_start.global_position
		bullet.rotation = parent.rotation
		bullet.velocity = shoot_direction * bullet_speed
		bullet.walls = parent.game.walls
		parent.velocity += -shoot_direction * gun_knockback_acceleration
	else:
		print("out of ammo")
