extends Node3D

@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

@onready var last_score_label: Label3D = $BehindScoreBoard/LastScoreLabel
@onready var rows: Array[Label3D] = [
	$BehindScoreBoard/ScoresContainer/Row1,
	$BehindScoreBoard/ScoresContainer/Row2,
	$BehindScoreBoard/ScoresContainer/Row3,
	$BehindScoreBoard/ScoresContainer/Row4,
	$BehindScoreBoard/ScoresContainer/Row5
]

func _ready() -> void:
	if player_scene:
		var player = player_scene.instantiate()
		add_child(player)
		for pistol in get_tree().get_nodes_in_group("pistols"):
			if "infinite_ammo" in pistol:
				pistol.infinite_ammo = true
			if pistol.has_method("add_ammo"):
				pistol.add_ammo(3)

	display_scores()

func display_scores() -> void:
	if not has_node("/root/GameManager"):
		return

	var current_time = GameManager.current_run_time
	last_score_label.text = "THIS RUN: " + GameManager.format_time(current_time)

	var scores = GameManager.highscores
	var highlighted_current = false

	for i in range(rows.size()):
		if i < scores.size():
			var score_val = scores[i]
			rows[i].text = "%d.  %s" % [i + 1, GameManager.format_time(score_val)]
			
			# Ist dieser Eintrag der gerade gespielte Run? (Einmalig gelb färben)
			if not highlighted_current and is_equal_approx(score_val, current_time):
				rows[i].modulate = Color(1.0, 0.85, 0.1, 1.0) # Gelb
				highlighted_current = true
			else:
				rows[i].modulate = Color(1.0, 1.0, 1.0, 1.0) # Weiß
		else:
			rows[i].text = "%d.  --:--" % [i + 1]
			rows[i].modulate = Color(0.4, 0.4, 0.4, 1.0) # Ausgegraut

func trigger_restart() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func trigger_quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
