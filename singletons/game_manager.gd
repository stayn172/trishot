extends Node

const SAVE_PATH = "user://highscores.save"

var current_run_time: float = 0.0
var highscores: Array = []

func _ready() -> void:
	load_scores()

func record_run_time(time_survived: float) -> void:
	current_run_time = time_survived
	highscores.append(time_survived)
	highscores.sort()
	highscores.reverse() # Höchste Zeiten nach oben
	if highscores.size() > 5:
		highscores.resize(5)
	save_scores()

func format_time(seconds_val: float) -> String:
	var mins: int = int(seconds_val) / 60
	var secs: int = int(seconds_val) % 60
	return "%02d:%02d" % [mins, secs]

func save_scores() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(highscores)

func load_scores() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var data = file.get_var()
			if data is Array:
				highscores = data
