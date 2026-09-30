extends Node3D

@export var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
@export var spawn_radius: float = 14.0
@export var max_active_enemies: int = 3 # Maximal 3 Gegner gleichzeitig

@export var initial_spawn_interval: float = 3.5
@export var min_spawn_interval: float = 0.8
@export var initial_enemy_speed: float = 1.2
@export var max_enemy_speed: float = 3.8

@export var ramp_up_duration: float = 120.0

var elapsed_time: float = 0.0
var spawn_timer: Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = initial_spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _process(delta: float) -> void:
	elapsed_time += delta
	var progress = clamp(elapsed_time / ramp_up_duration, 0.0, 1.0)
	spawn_timer.wait_time = lerp(initial_spawn_interval, min_spawn_interval, progress)

func _on_spawn_timer_timeout() -> void:
	if not enemy_scene:
		return

	# Nur spawnen, wenn weniger als max_active_enemies existieren
	var current_enemies = get_tree().get_nodes_in_group("enemies")
	if current_enemies.size() >= max_active_enemies:
		return

	var progress = clamp(elapsed_time / ramp_up_duration, 0.0, 1.0)
	var current_speed = lerp(initial_enemy_speed, max_enemy_speed, progress)

	var angle = randf() * TAU
	var spawn_pos = Vector3(cos(angle), 0, sin(angle)) * spawn_radius

	var enemy = enemy_scene.instantiate() as CharacterBody3D
	enemy.speed = current_speed
	
	get_tree().root.add_child(enemy)
	enemy.global_position = spawn_pos
