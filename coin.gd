extends Node3D

func _ready() -> void:
	$Area3D.body_entered.connect(on_pickup)
	$AnimationPlayer.play("idle")

func on_pickup(_body: Node3D) -> void:
	if _body.name == "Player" or _body.name == "Spear":
		GameState.coins += 1
		GameSignals.coin_pickup.emit()
		queue_free()
	
