extends Node3D

func _ready() -> void:
	$d1.position.x = randi_range(-10, 10)
	$d2.position.x = randi_range(-20, 20)
	$d3.position.x = randi_range(-15, 15)
	$d4.position.x = randi_range(-10, 10)
