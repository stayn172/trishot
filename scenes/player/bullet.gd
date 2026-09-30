extends RigidBody3D

@export var speed: float = 40.0
@export var lifetime: float = 3.0

var source_weapon: Node = null

func _ready() -> void:
	add_to_group("bullets")
	gravity_scale = 0.0
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	linear_velocity = -global_transform.basis.z * speed

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	# Menü-Button Treffer (Game Over Screen)
	if body.name == "RestartButton":
		var game_over = get_tree().current_scene
		if game_over and game_over.has_method("trigger_restart"):
			game_over.trigger_restart()
		queue_free()
		return
	elif body.name == "QuitButton":
		var game_over = get_tree().current_scene
		if game_over and game_over.has_method("trigger_quit"):
			game_over.trigger_quit()
		queue_free()
		return

	# Gegner Treffer
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		if is_instance_valid(source_weapon) and source_weapon.has_method("add_ammo"):
			source_weapon.add_ammo(2)
		body.take_damage()
		queue_free()
	elif body is StaticBody3D:
		queue_free()
