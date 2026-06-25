extends RichTextLabel
class_name Message

func _ready() -> void:
	size = Vector2(128, 128)
	add_theme_font_size_override("normal_font_size", 16)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.2)
	tween.finished.connect(queue_free)
