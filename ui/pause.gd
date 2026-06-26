extends Control
class_name Pause

#@onready var head: UIHead = $".."
@onready var dim: ColorRect = $Dim
@onready var rect: ColorRect = $ColorRect
@onready var fullscreen_toggle: CheckButton = $ColorRect/VBoxContainer/FullScreenToggle
@onready var master_slider: HSlider = $ColorRect/VBoxContainer/MasterSlider
@onready var sound_slider: HSlider = $ColorRect/VBoxContainer/SoundSlider
@onready var music_slider: HSlider = $ColorRect/VBoxContainer/MusicSlider
@onready var return_mm: Button = $ColorRect/VBoxContainer/ReturnMainMenu

var paused: bool = false
var window_dimensions: Vector2i
var read_input: bool = true

func _ready() -> void:
	window_dimensions = DisplayServer.window_get_size()
	fullscreen_toggle.pressed.connect(toggle_fullscreen)
	_on_window_change()
	master_slider.min_value = -12.0
	master_slider.max_value = 12.0
	master_slider.value = AudioServer.get_bus_volume_db(0)
	master_slider.value_changed.connect(
		func(value): AudioServer.set_bus_volume_db(0, value)
			)
	sound_slider.min_value = -12.0
	sound_slider.max_value = 12.0
	sound_slider.value = AudioServer.get_bus_volume_db(1)
	sound_slider.value_changed.connect(
		func(value): AudioServer.set_bus_volume_db(1, value)
			)
	music_slider.min_value = -12.0
	music_slider.max_value = 12.0
	music_slider.value = AudioServer.get_bus_volume_db(2)
	music_slider.value_changed.connect(
		func(value): AudioServer.set_bus_volume_db(2, value)
			)
	return_mm.button_down.connect(unpause)
	
	master_slider.value_changed.connect(
		func(value): check_for_silence(master_slider, value)
	)
	sound_slider.value_changed.connect(
		func(value): check_for_silence(sound_slider, value)
	)
	music_slider.value_changed.connect(
		func(value): check_for_silence(music_slider, value)
	)
	
func check_for_silence(slider: HSlider, value: float) -> void:
	var bus: int
	match slider:
		master_slider:
			bus = 0
		sound_slider:
			bus = 1
		music_slider:
			bus = 2
	if value == slider.min_value:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)

func unpause() -> void: 
	if read_input:
		get_tree().change_scene_to_file("res://main_menu.tscn")
	else:
		paused = false
		on_pause_changed(paused)

func toggle_fullscreen() -> void:
	if fullscreen_toggle.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#_on_window_change()	

func on_pause_changed(value: bool) -> void:
	if value: 
		_on_window_change()
		get_tree().paused = true
		mouse_filter = Control.MOUSE_FILTER_STOP
		dim.visible = true
		var fade_tween = create_tween()
		dim.modulate.a = 0.0
		fade_tween.tween_property(dim, "modulate:a", 0.5, 0.2)
		
		rect.visible = true
		var rect_tween = create_tween()
		rect.position.y = 360
		rect_tween.tween_property(rect, "position:y", 50.0, 0.1)
		master_slider.value = AudioServer.get_bus_volume_db(0)
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var fade_tween = create_tween()
		fade_tween.tween_property(dim, "modulate:a", 0.0, 0.2)
		fade_tween.finished.connect(func(): dim.visible = false)
		
		var rect_tween = create_tween()
		rect_tween.tween_property(rect, "position:y", 260.0, 0.1)
		rect_tween.finished.connect(func(): rect.visible = false)
		
		fade_tween.finished.connect(func(): get_tree().paused = false)

func _on_window_change() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_dimensions = DisplayServer.window_get_size()
		fullscreen_toggle.button_pressed = true
	else:
		DisplayServer.window_set_size(window_dimensions)
		fullscreen_toggle.button_pressed = false	

func _process(_delta: float) -> void:
	if read_input and Input.is_action_just_pressed("ui_cancel"):
		paused = not paused
		on_pause_changed(paused)
	if Input.is_action_just_pressed("ui_exit"):
		fullscreen_toggle.button_pressed = false

			
	
