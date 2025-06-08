extends Control

@onready var apple_distance: Label = $AppleInfo/VBoxContainer/AppleDistance
@onready var rot_distance: Label = $RotInfo/VBoxContainer/RotDistance
@onready var rot_speed: Label = $RotInfo/VBoxContainer/RotSpeed
@onready var player_vel: Label = $PlayerInfo/VBoxContainer/PlayerSpeed
@onready var dash_info: Label = $PlayerInfo/VBoxContainer/Dash
@onready var coins: Label = $PlayerInfo/VBoxContainer/Coins
@onready var sens_slider: HSlider = $Paused/Options/VBoxContainer2/Sens

func _ready() -> void:
	GameSignals.player_death.connect(game_over)
	$GameOver/VBoxContainer/RestartButton.pressed.connect(restart)
	sens_slider.value = Options.mouse_sens
	sens_slider.drag_ended.connect(func(_value: float): Options.mouse_sens = sens_slider.value)
	GameSignals.prompt.connect(update_prompt)
	GameSignals.vending_interact.connect(func():
		get_tree().paused = true
		$ShopInterface.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		)
	
func update_prompt(prompt: String) -> void:
	$Prompt.text = prompt

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and !$ShopInterface.visible:
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
	player_vel.text = str(snapped(GameState.player_velocity.length(), 0.001)) + "m/s"
	coins.text = str(GameState.coins) + " coins"
	if GameState.dash_time == 0:
		dash_info.text = "dash ready"
	else:
		dash_info.text = "dash ready in " + str(snapped(GameState.dash_time, 0.01)) + "s"
	
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
