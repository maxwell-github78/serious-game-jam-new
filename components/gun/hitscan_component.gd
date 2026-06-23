extends GunComponent
class_name HitscanComponent

@export_category("Shooting")
@export var max_range = 1000.0
@export var damage: int = 10

func shoot() -> void:
	if rounds > 0 or infinite_ammo: 
		rounds -= 1
		var direction := get_global_mouse_position() - parent.position 
		direction = direction.normalized()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(parent.bullet_start.global_position, parent.bullet_start.global_position + direction * max_range)
		var result := space_state.intersect_ray(query)
		var trail: Trail
		parent.velocity += -direction * gun_knockback_acceleration
		if result: 
			trail = Trail.new(parent.bullet_start.global_position, result.position)
			print("hit: ", result.collider)
			for child in result.collider.get_children():
				if child is HealthComponent:
					child.take_damage(damage)
					result.collider.velocity = direction * gun_knockback_acceleration
			
		else:
			trail = Trail.new(parent.bullet_start.global_position, parent.bullet_start.global_position + direction * max_range)
			print("miss")
		parent.game.projectiles.add_child(trail)
	else:
		print("out of ammo")

	
