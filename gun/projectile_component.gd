extends GunComponent
class_name ProjectileComponent

@export_category("Shooting")
@export var bullet_speed = 1600.0

func shoot() -> void:
	if rounds > 0:
		rounds -= 1
		var bullet: Bullet = packed_bullet.instantiate()
		var shoot_direction := get_global_mouse_position() - parent.position
		shoot_direction = shoot_direction.normalized()
		bullet.position = parent.bullet_start.global_position
		bullet.rotation = parent.rotation
		bullet.velocity = shoot_direction * bullet_speed
		bullet.walls = parent.game.walls
		parent.game.projectiles.add_child(bullet)
		parent.velocity += -shoot_direction * gun_knockback_acceleration
	else:
		print("out of ammo")
