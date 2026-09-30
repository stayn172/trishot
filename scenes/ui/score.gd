extends Label3D

var survival_time: float = 0.0

func _process(delta: float) -> void:
	survival_time += delta
	if has_node("/root/GameManager"):
		GameManager.current_run_time = survival_time
	
	var minutes: int = int(survival_time) / 60
	var seconds: int = int(survival_time) % 60
	text = "Time: %02d:%02d" % [minutes, seconds]
