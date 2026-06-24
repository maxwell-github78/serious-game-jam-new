extends GunComponent
class_name ProjectileComponent

var bullet_speed: float
var damage: int

var packed_bullet: PackedScene
var texture: Texture2D
var spin: bool

func shoot() -> void:
	if rounds > 0 or infinite_ammo:
		rounds -= 1
		var bullet: Bullet = packed_bullet.instantiate()
		parent.game.projectiles.add_child(bullet)
		var shoot_rotation := parent.rotation
		var shoot_direction = Vector2(cos(shoot_rotation), sin(shoot_rotation))
		shoot_direction = shoot_direction.normalized()
		bullet.spin = spin
		bullet.damage = parent.damage * StatChanges.get_multiplier(StatChanges.multiplier_keys.ENEMY_DAMAGE)
		bullet.position = parent.bullet_start.global_position
		bullet.rotation = parent.rotation
		bullet.velocity = shoot_direction * bullet_speed
		bullet.knockback = gun_knockback_acceleration
		parent.velocity += -shoot_direction * gun_knockback_acceleration
	else:
		print("out of ammo")
