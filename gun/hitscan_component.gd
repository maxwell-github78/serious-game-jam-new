extends GunComponent
class_name HitscanComponent

@export_category("Shooting")
@export var max_range = 1000.0

func shoot() -> void:
	if rounds > 0: 
		var direction := get_global_mouse_position() - parent.position 
		direction = direction.normalized()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(parent.bullet_start.global_position, parent.bullet_start.global_position + direction * max_range)
		var result := space_state.intersect_ray(query)
		parent.velocity += -direction * gun_knockback_acceleration
		if result: 
			print("hit: ", result.collider)
			
		else:
			print("miss")
	else:
		print("out of ammo")

	
