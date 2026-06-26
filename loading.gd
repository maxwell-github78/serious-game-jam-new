extends Control
@onready var progress_bar: ProgressBar = $Progress

var next_scene_path: String = "res://main.tscn"
var progress: Array[float] = []

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene_path,)

func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	match status: 
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene := ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(scene)
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#print(progress[0] * 100.0)
			progress_bar.value = progress[0] * 100.0
			
