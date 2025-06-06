extends StaticBody3D

var can_stab: bool = true

func _ready() -> void:
	$CooldownTimer.timeout.connect(func(): can_stab = true)
	$Hitbox.area_entered.connect(apply_force)
	
func apply_force(area: Area3D) -> void:
	var apple: RigidBody3D = area.get_parent()
	var direction: Vector3 = (global_position - apple.global_position).normalized()
	apple.hit(direction * Vector3(50, 50, 100))

func stab() -> void:
	if can_stab:
		can_stab = false
		$AnimationPlayer.play("stab")
		$AnimationPlayer.queue("RESET")
		$CooldownTimer.start()
