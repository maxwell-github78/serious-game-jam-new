extends Control
class_name UIPickSubstance

var substances: Array

@onready var head: UIHead = $".."
@onready var dizzy: TextureRect = $"../DizzySubstance"

var spacing_width := 160
var rect_width := 128

var chosen: Substance

const wheel_textures: Array = [
	preload("res://assets/textures/wheel/wheel1.png"),
	preload("res://assets/textures/wheel/wheel2.png"),
	preload("res://assets/textures/wheel/wheel3.png"),
	preload("res://assets/textures/wheel/wheel4.png")
]


const effect_descriptions := {
	StatChanges.multiplier_keys.PLAYER_DAMAGE: "the damage dealt by Dizzy",
	StatChanges.multiplier_keys.ENEMY_DAMAGE: "the damage dealt by Enemies",
	StatChanges.multiplier_keys.PLAYER_MOVESPEED: "Dizzy's movement speed",
	StatChanges.multiplier_keys.ENEMY_MOVESPEED: "the Enemy's movement speed",
	StatChanges.multiplier_keys.PLAYER_RELOADTIME: "Dizzy's reload time",
	StatChanges.multiplier_keys.ENEMY_FIRE_WAIT_TIME: "the Enemy's time to shoot",
	StatChanges.multiplier_keys.ENEMY_SPAWN_RATE: "the difficulty of each room",
	StatChanges.multiplier_keys.ENEMY_PROJECTILE_SPEED: "the speed of Enemy projectiles",
	StatChanges.multiplier_keys.PLAYER_HEALTH: "Dizzy's hitpoints",
	StatChanges.multiplier_keys.PLAYER_DODGE_CHANCE: "Dizzy's chance to dodge projectiles"
}

var font: Font = preload("res://assets/fonts/kenney-pixel.ttf")


func _ready() -> void:
	font.antialiasing = true
	substances = Files.read_definitions("res://assets/definitions/substances").values()
	@warning_ignore("integer_division")
	position.x = (640 - 3 * spacing_width) / 2
	
func setup_signal() -> void:
	head.game.room_cleared.connect(show_substances)

func show_substances() -> void: 
	head.game.picking_substance = true
	var timer := Timer.new()
	add_child(timer)
	timer.start(0.3)
	await timer.timeout
	timer.queue_free()
	for i in range(3):
		var rect := ColorRect.new()
		rect.color = Color.BLACK
		rect.size = Vector2(rect_width, 270)
		rect.position = Vector2(i * spacing_width, 360)
		@warning_ignore("integer_division")
		rect.position.x += (spacing_width - rect_width) / 2
		add_child(rect)
		var tween := create_tween()
		tween.tween_property(rect, "position:y", 0, 0.2)
		
		var substance: Substance = substances.pick_random()
		var texture_rect := TextureRect.new()
		texture_rect.texture = substance.texture
		texture_rect.position.x = (rect_width - 64.0) / 2
		texture_rect.position.y = 32
		rect.add_child(texture_rect)
		
		var flavour_text := RichTextLabel.new()
		flavour_text.size = Vector2(64, 12)
		flavour_text.position.y = texture_rect.position.y + texture_rect.size.y + 2
		flavour_text.position.x = 32
		flavour_text.text = substance.flavour_text
		flavour_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		flavour_text.add_theme_font_size_override("normal_font_size", 16)
		flavour_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#flavour_text.add_theme_font_override("normal_font", font)
		rect.add_child(flavour_text)
	
		var name_text := RichTextLabel.new()
		name_text.size = Vector2(108, 24)
		name_text.position.y = 10
		name_text.position.x = 10
		name_text.text = substance.display_name
		name_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_text.add_theme_font_size_override("normal_font_size", 16)
		name_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#name_text.add_theme_font_override("normal_font", font)
		rect.add_child(name_text)
		
		var effects_text := RichTextLabel.new()
		effects_text.size = Vector2(108, 128)
		effects_text.position.y = flavour_text.position.y + flavour_text.size.y + 10
		effects_text.position.x = 10
		effects_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		effects_text.add_theme_font_size_override("normal_font_size", 16)
		effects_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		effects_text.text = get_effects_text(substance)
		#effects_text.add_theme_font_override("normal_font", font)
		rect.add_child(effects_text)
		
		var button := SubstanceButton.new()
		button.size = rect.size
		#button.visible = false
		var stylebox_normal := StyleBoxFlat.new()
		stylebox_normal.bg_color = Color(0, 0, 0, 0)
		var stylebox_hovered := StyleBoxFlat.new()
		stylebox_hovered.bg_color = Color(1, 0.8, 0.8, 0.2)
		button.add_theme_stylebox_override("normal", stylebox_normal)
		button.add_theme_stylebox_override("hover", stylebox_hovered)
		button.chosen_substance.connect(_on_chosen_substance)
		button.substance = substance
		rect.add_child(button)
		
func _on_chosen_substance(substance: Substance) -> void:
	chosen = substance
	dizzy.visible = true
	dizzy.modulate.a = 0.0
	var dizzy_in_tween = create_tween()
	dizzy_in_tween.tween_property(dizzy, "modulate:a", 1.0, 0.2)
	
	for rect in get_children():
		var tween = create_tween()
		tween.tween_property(rect, "position:y", 364, 0.2)
		tween.finished.connect(rect.queue_free)
		
	var icon := TextureRect.new()
	icon.size = Vector2(64, 64)
	icon.texture = substance.texture
	icon.position = Vector2(370, 0)
	dizzy.add_child(icon)
	var icon_in_tween = create_tween()
	icon_in_tween.tween_property(icon, "position:y", 160, 0.2)
	
	var wheel := create_wheel()
	wheel.finished_spinning.connect(handle_dosage)
	
	var dosage_text := RichTextLabel.new()
	dosage_text.text = "SPIN TO REVEAL THE DOSAGE"
	dosage_text.size = Vector2(256, 256)
	dosage_text.position =  Vector2(32, 175)
	dosage_text.add_theme_font_size_override("normal_font_size", 32)
	dosage_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dizzy.add_child(dosage_text)
		
	

func handle_dosage(dosage: float):
	var timer := Timer.new()
	add_child(timer)
	timer.start(0.5)
	await timer.timeout
	StatChanges.apply_effects(chosen, dosage)
	for child in dizzy.get_children():
		child.queue_free()
	var dizzy_out_tween := create_tween()
	dizzy_out_tween.tween_property(dizzy, "modulate:a", 0.0, 0.4)
	head.game.picking_substance = false

func create_wheel() -> Wheel:
	var wheel := Wheel.new()
	wheel.position = Vector2(128, 100)
	wheel.textures = wheel_textures
	dizzy.add_child(wheel)
	return wheel
	
	

func get_effects_text(substance: Substance) -> String:
	var string: String = ""
	for key in substance.effects.keys():
		var multiplier = substance.effects[key]
		var increase_decrease: String
		var percentage_change: String
		var line: String
		var stat_descriptor: String
		
		if key in effect_descriptions:
				stat_descriptor = effect_descriptions[key]
		else:
			stat_descriptor = "[MISSING]"
		
		if not key in StatChanges.add_instead:
			if multiplier > 1.0: 
				increase_decrease = "Increases "
				percentage_change = var_to_str(int(round((multiplier - 1.0) * 100)))
			else:
				increase_decrease = "Decreases "
				percentage_change = var_to_str(int(round((1.0 - multiplier) * 100)))
				
			line = "-" + increase_decrease + stat_descriptor + " by " + percentage_change + "%\n"
			
		else:
			if multiplier > 0.0:
				increase_decrease = "Increases "
				if key == StatChanges.multiplier_keys.PLAYER_DODGE_CHANCE:
					percentage_change = var_to_str(int(round((multiplier) * 100)))
					line = "-" + increase_decrease + stat_descriptor + " by " + percentage_change + "% (max 80%)\n" 
				elif key == StatChanges.multiplier_keys.PLAYER_HEALTH: 
					percentage_change = var_to_str(int(round(multiplier)))
					line = "-" + increase_decrease + stat_descriptor + " by " + percentage_change + "\n"
			
		string += line

	return string
		
		
	
		
