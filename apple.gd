extends RigidBody3D

func _physics_process(delta: float) -> void:
	GameState.apple_position = global_position
	
