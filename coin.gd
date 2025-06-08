extends Node3D

func _ready() -> void:
	$Area3D.body_entered.connect(on_pickup)
	$AnimationPlayer.play("idle")
	$GPUParticles3D.finished.connect(queue_free)

func on_pickup(_body: Node3D) -> void:
	if _body.name == "Player" or _body.name == "Spear":
		$Area3D/CollisionShape3D.set_deferred("disabled", true)
		GameState.coins += 1
		GameSignals.coin_pickup.emit()
		$GPUParticles3D.emitting = true
		get_tree().create_timer(0.1).timeout.connect(func(): $Area3D.visible = false)
	
