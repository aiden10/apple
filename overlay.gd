extends Control

@onready var apple_distance: Label = $AppleInfo/VBoxContainer/AppleDistance
@onready var rot_distance: Label = $RotInfo/VBoxContainer/RotDistance
@onready var rot_speed: Label = $RotInfo/VBoxContainer/RotSpeed
@onready var sens_slider: HSlider = $Paused/Options/VBoxContainer2/Sens

func _ready() -> void:
	GameSignals.player_death.connect(game_over)
	$GameOver/VBoxContainer/RestartButton.pressed.connect(restart)
	sens_slider.value = Options.mouse_sens
	sens_slider.drag_ended.connect(func(_value: float): Options.mouse_sens = sens_slider.value)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			$Paused.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			$Paused.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	apple_distance.text = str(snapped((GameState.apple_position.z + 5) * -1, 0.1)) + "m traveled"
	rot_distance.text = str(snapped(abs(GameState.player_position.z - GameState.rot_position.z), 0.1)) + "m away"
	rot_speed.text = str(snapped(GameState.rot_speed, 0.001)) + "m/s"
	
func restart() -> void:
	$GameOver.visible = false
	$Crosshair.visible = true
	$AppleInfo.visible = true
	$RotInfo.visible = true
	GameSignals.restart.emit()

func game_over() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Crosshair.visible = false
	$AppleInfo.visible = false
	$RotInfo.visible = false
	$GameOver.visible = true
	$GameOver/VBoxContainer/ScoreLabel.text = "the apple stayed fresh for: " + str(snapped((GameState.apple_position.z + 5) * -1, 0.1)) + " meters"
	get_tree().paused = true
