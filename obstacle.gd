extends Node3D

func _ready() -> void:
	for child in get_children():
		if child is Area3D:
			child.body_entered.connect(collision)

func collision(body: Node3D) -> void:
	if body.name == "Player":
		GameSignals.player_death.emit()
		print("dead")
