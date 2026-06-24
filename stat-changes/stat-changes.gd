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
	for key in stat_multipliers.keys():
		stat_multipliers[key] = 1.0
	
