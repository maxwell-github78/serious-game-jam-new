extends Control
class_name UIPickSubstance

var substances: Array

@onready var head: UIHead = $".."

var spacing_width := 160
var rect_width := 128

const effect_descriptions := {
	StatChanges.multiplier_keys.PLAYER_DAMAGE: "damage dealt by Dizzy",
	StatChanges.multiplier_keys.ENEMY_DAMAGE: "damage dealt by Enemies",
	StatChanges.multiplier_keys.PLAYER_MOVESPEED: "Dizzy's movement speed",
	StatChanges.multiplier_keys.ENEMY_MOVESPEED: "Enemy movement speed",
	StatChanges.multiplier_keys.PLAYER_RELOADTIME: "Dizzy's reload time",
	StatChanges.multiplier_keys.ENEMY_FIRE_WAIT_TIME: "Enemy time to shoot"
}

var font: Font = preload("res://assets/fonts/kenney-pixel.ttf")


func _ready() -> void:
	font.antialiasing = true
	substances = Files.read_definitions("res://assets/definitions/substances/").values()
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
		rect.size = Vector2(rect_width, 240)
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
		effects_text.size = Vector2(108, 64)
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
	StatChanges.apply_effects(substance)
	for rect in get_children():
		var tween = create_tween()
		tween.tween_property(rect, "position:y", 360, 0.2)
		tween.finished.connect(rect.queue_free)
	head.game.picking_substance = false

func get_effects_text(substance: Substance) -> String:
	var string: String = ""
	for key in substance.effects.keys():
		var multiplier = substance.effects[key]
		var increase_decrease: String
		var percentage_change: String
		if multiplier > 1.0: 
			increase_decrease = "Increases "
			percentage_change = var_to_str(int(round((multiplier - 1.0) * 100)))
		else:
			increase_decrease = "Decreases "
			percentage_change = var_to_str(int(round((1.0 - multiplier) * 100)))
			
		var stat_descriptor: String
		if key in effect_descriptions:
			stat_descriptor = effect_descriptions[key]
		else:
			stat_descriptor = "[MISSING]"
		
		var line: String = increase_decrease + stat_descriptor + " by " + percentage_change + "%\n"
		string += line

	return string
		
		
	
		
