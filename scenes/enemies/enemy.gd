extends CharacterBody3D

@export var speed: float = 1.2
@export var attack_radius: float = 0.6
var target: Node3D = null
var is_game_over: bool = false

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]
	else:
		target = get_tree().root.find_child("XRCamera3D", true, false)

func _physics_process(_delta: float) -> void:
	# Abbruch, wenn bereits Game Over oder Node nicht mehr im Tree ist
	if is_game_over or not is_inside_tree() or not is_instance_valid(target):
		return

	var target_pos = target.global_position
	var flat_target = Vector3(target_pos.x, global_position.y, target_pos.z)

	var dist = global_position.distance_to(flat_target)

	if dist <= attack_radius:
		trigger_game_over()
		return

	look_at(flat_target, Vector3.UP)
	var dir = (flat_target - global_position).normalized()
	velocity = dir * speed

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider == target or (collider and collider.is_in_group("player")):
			trigger_game_over()
			return

func take_damage() -> void:
	queue_free()

func trigger_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	
	# Physik sofort stoppen
	set_physics_process(false)

	if has_node("/root/GameManager"):
		GameManager.record_run_time(GameManager.current_run_time)

	# Neuer Pfad entsprechend deiner Ordnerstruktur
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
