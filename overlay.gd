extends Control

@onready var distance_label: Label = $DistanceLabel

func _process(delta: float) -> void:
	distance_label.text = str(floor(GameState.apple_position.z * -1))
