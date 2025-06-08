extends RigidBody3D
@onready var hit_effect: GPUParticles3D = $HitEffect

var antigrav_color: Color = Color(0.28, 0.5, 1.0, 1.0)
var recurring_color: Color = Color(0.8, 0.4, 0.24, 1.0)
var ghost_color: Color = Color(1.0, 1.0, 1.0, 0.5)
var gold_color: Color = Color(0.93, 0.8, 0.2, 1.0)
var ability_active: bool = true
var coin_scene: PackedScene = preload("res://coin.tscn")
var recall: bool = false

func _ready() -> void:
	var outline_material: StandardMaterial3D = load("res://apple_outline.tres")
	GameSignals.antigrav_purchase.connect(func():
		outline_material.albedo_color = antigrav_color
		$MeshInstance3D/Outline.set_surface_override_material(0, outline_material)
	)
	GameSignals.recurring_purchase.connect(func():
		outline_material.albedo_color = recurring_color
		$MeshInstance3D/Outline.set_surface_override_material(0, outline_material)
	)
	GameSignals.ghost_purchase.connect(func():
		outline_material.albedo_color = ghost_color
		$MeshInstance3D/Outline.set_surface_override_material(0, outline_material)
	)
	GameSignals.gold_purchase.connect(func():
		outline_material.albedo_color = gold_color
		$MeshInstance3D/Outline.set_surface_override_material(0, outline_material)
	)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ability") and ability_active:
		if GameState.apple_variety == "antigrav":
			gravity_scale *= -1
		elif GameState.apple_variety == "recurring":
			recall = true

func _integrate_forces(state : PhysicsDirectBodyState3D) -> void:
	if recall:
		state.transform.origin = Vector3(GameState.player_position.x, GameState.player_position.y + 3, GameState.player_position.z)
		recall = false

func _physics_process(delta: float) -> void:
	GameState.apple_position = global_position

func spawn_coin() -> void:
	var coin: Node3D = coin_scene.instantiate()
	add_child(coin)
	coin.global_position = global_position

func hit(force: Vector3):
	physics_material_override.friction = 0.8 - (GameState.apple_roll_inc * GameState.apple_roll_stat)
	apply_central_impulse(force)
	hit_effect.emitting = true
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.5, 1.5)
	$AudioStreamPlayer3D.play()
	if randf() > 0.5 and GameState.apple_variety == "gold":
		spawn_coin()
