extends Node3D

var usable: bool = false

func _ready() -> void:
	$DetectionRange.body_entered.connect(body_detected)
	$DetectionRange.body_exited.connect(body_exited)
	
func body_detected(body: Node3D) -> void:
	if body.name == "Player":
		$StaticBody3D/Outline.visible = true
		usable = true
		GameSignals.prompt.emit("press e to use")
		
func body_exited(body: Node3D) -> void:
	if body.name == "Player":
		$StaticBody3D/Outline.visible = false
		usable = false
		GameSignals.prompt.emit("")

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("interact") and usable:
		GameSignals.vending_interact.emit()
		
