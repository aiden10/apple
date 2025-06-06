extends Control

@onready var distance_label: Label = $DistanceLabel

func _ready() -> void:
	GameSignals.player_death.connect(game_over)
	$GameOver/VBoxContainer/RestartButton.pressed.connect(restart)
	
func _process(delta: float) -> void:
	distance_label.text = str(snapped((GameState.apple_position.z + 5) * -1, 0.1))

func restart() -> void:
	$GameOver.visible = false
	$Crosshair.visible = true
	$DistanceLabel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	GameSignals.restart.emit()
	
func game_over() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Crosshair.visible = false
	$DistanceLabel.visible = false
	$GameOver.visible = true
	$GameOver/VBoxContainer/ScoreLabel.text = "the apple stayed fresh for: " + distance_label.text + " meters"
	get_tree().paused = true
