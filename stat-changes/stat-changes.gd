extends Node

enum multiplier_keys {
	PLAYER_DAMAGE, 
	ENEMY_DAMAGE,
	PLAYER_MOVESPEED,
	ENEMY_MOVESPEED,
	PLAYER_RELOADTIME,
	ENEMY_FIRE_WAIT_TIME,
	ENEMY_SPAWN_RATE,
	ENEMY_PROJECTILE_SPEED, 
	PLAYER_HEALTH, 
	PLAYER_DODGE_CHANCE,
	PLAYER_DEATH_TIME,
}

const add_instead: Array[multiplier_keys] = [multiplier_keys.PLAYER_HEALTH, multiplier_keys.PLAYER_DODGE_CHANCE]

var stat_multipliers: Dictionary[multiplier_keys, float]

var game: Game

func init(in_game: Game) -> void: 
	game = in_game
	for key in range(multiplier_keys.size()):
		if key in add_instead: 
			stat_multipliers[key] = 0.0
		else:
			stat_multipliers[key] = 1.0

func get_multiplier(key: multiplier_keys) -> float:
	return stat_multipliers[key]

func apply_effects(resource: Substance, dosage: float) -> void:
	for key in resource.effects.keys():
		if not (key in add_instead): 
			var multiplier: float = resource.effects[key]
			var factor: float = pow(multiplier, dosage)
			stat_multipliers[key] *= factor
		else: 
			stat_multipliers[key] += resource.effects[key] * dosage
			if key == multiplier_keys.PLAYER_HEALTH:
				game.player.health_component.max_health += resource.effects[key] * dosage
				game.player.health_component.health += resource.effects[key] * dosage
			elif key == multiplier_keys.PLAYER_DODGE_CHANCE:
				game.player.dodge_chance += resource.effects[key] * dosage
				
		
