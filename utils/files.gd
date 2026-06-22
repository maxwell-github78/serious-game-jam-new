class_name Files
extends Object

static func read_files(path_string: String, suffix: String):
	var dir := DirAccess.open(path_string)
	var out: Dictionary = {}
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var file_path_string: String
		var key: String
		while file_name != "":
			file_path_string = path_string + "/" + file_name
			key = file_name.replace(suffix, "")
			out[key] = load(file_path_string)
			file_name = dir.get_next()
		return out 
	else:
		print("An error occurred static func read_files")
		return false 

static func read_definitions(path_string: String):
	return read_files(path_string, ".tres")

static func read_scenes(path_string: String):
	return read_files(path_string, ".tscn")
