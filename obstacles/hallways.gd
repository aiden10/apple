extends Node3D

var x_positions: Array[int] = [-9, -3, 3, 9]

func _ready() -> void:
	$BackWall.position.x = randi_range(-12, 12)
	x_positions.shuffle()
	$Coin.global_position = Vector3(x_positions[0], 1, -15)
	$VendingMachine.global_position = Vector3(x_positions[1], 0, -15)
	$TripleCoin.global_position = Vector3(x_positions[2], 1, -15)
