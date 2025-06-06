extends Node3D

@onready var stage: Node3D = $Stage

func _physics_process(delta: float) -> void:
	stage.global_position.z -= 0.01
