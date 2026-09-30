extends Node3D

@export var max_ammo: int = 3
var ammo: int = 3
var infinite_ammo: bool = false

@export var bullet_scene: PackedScene = preload("res://scenes/player/bullet.tscn")
@onready var muzzle: Marker3D = $Muzzle
@onready var bars: Array[MeshInstance3D] = [
	$AmmoBars/Bar1,
	$AmmoBars/Bar2,
	$AmmoBars/Bar3
]

var mat_yellow: StandardMaterial3D
var mat_grey: StandardMaterial3D
var controller: XRController3D

func _ready() -> void:
	add_to_group("pistols")
	controller = get_parent() as XRController3D
	if controller:
		controller.button_pressed.connect(_on_controller_button_pressed)

	mat_yellow = StandardMaterial3D.new()
	mat_yellow.albedo_color = Color(1.0, 0.9, 0.0)
	mat_yellow.emission_enabled = true
	mat_yellow.emission = Color(1.0, 0.8, 0.0)
	mat_yellow.emission_energy_multiplier = 2.0

	mat_grey = StandardMaterial3D.new()
	mat_grey.albedo_color = Color(0.2, 0.2, 0.2)
	mat_grey.emission_enabled = false

	update_ammo_display()

func _on_controller_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click":
		shoot()

func shoot() -> void:
	if not infinite_ammo and ammo <= 0:
		return
	if not bullet_scene:
		return

	if not infinite_ammo:
		ammo -= 1
		update_ammo_display()

	var bullet = bullet_scene.instantiate() as RigidBody3D
	if "source_weapon" in bullet:
		bullet.source_weapon = self

	bullet.global_transform = muzzle.global_transform
	get_tree().root.add_child(bullet)

func add_ammo(amount: int) -> void:
	ammo = clamp(ammo + amount, 0, max_ammo)
	update_ammo_display()

func update_ammo_display() -> void:
	for i in range(bars.size()):
		if infinite_ammo or i < ammo:
			bars[i].set_surface_override_material(0, mat_yellow)
		else:
			bars[i].set_surface_override_material(0, mat_grey)
