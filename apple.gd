extends RigidBody3D

@onready var hit_effect: GPUParticles3D = $HitEffect

func _physics_process(delta: float) -> void:
	GameState.apple_position = global_position
	
func hit(force: Vector3):
	apply_central_impulse(force)
	hit_effect.emitting = true
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.5, 1.5)
	$AudioStreamPlayer3D.play()
