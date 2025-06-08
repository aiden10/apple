extends StaticBody3D

var can_stab: bool = true

func _ready() -> void:
	$CooldownTimer.timeout.connect(func(): can_stab = true)
	$Hitbox.area_entered.connect(apply_force)

func apply_force(area: Area3D) -> void:
	var apple: RigidBody3D = area.get_parent()
	var direction: Vector3 = (global_position - apple.global_position).normalized()
	direction.y += max(0.2, randf())
	apple.hit(direction * Vector3(50, 50, 100) * ((GameState.knockback_inc * GameState.knockback_stat) + 1))

func stab() -> void:
	if can_stab:
		can_stab = false
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("stab")
		$AnimationPlayer.queue("RESET")
		$CooldownTimer.wait_time = 1.0 - (GameState.spear_cooldown_inc * GameState.spear_cooldown_stat)
		$CooldownTimer.start()
