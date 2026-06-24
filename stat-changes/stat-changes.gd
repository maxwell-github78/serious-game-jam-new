extends Node

enum multiplier_keys {
	PLAYER_DAMAGE, 
	ENEMY_DAMAGE,
	PLAYER_MOVESPEED,
	ENEMY_MOVESPEED,
	PLAYER_RELOADTIME,
	ENEMY_FIRE_WAIT_TIME
}

var stat_multipliers: Dictionary[multiplier_keys, float]

func init() -> void:
	for key in range(multiplier_keys.size()):
		stat_multipliers[key] = 1.0

func get_multiplier(key: multiplier_keys) -> float:
	return stat_multipliers[key]

func apply_effects(resource: Substance) -> void:
	for key in resource.effects.keys():
		stat_multipliers[key] *= resource.effects[key]
		
