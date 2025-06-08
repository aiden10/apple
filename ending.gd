extends Node3D

var usable: bool = false
var apple_scene: PackedScene
var apple_count: int = 0

func _ready() -> void:
	$CanvasLayer/Overlay/AppleInfo.visible = false
	$CanvasLayer/Overlay/AppleCount.visible = true
	$CanvasLayer/Overlay/RotInfo.visible = false
	$DetectionRange.body_entered.connect(body_detected)
	$DetectionRange.body_exited.connect(body_exited)
	apple_scene = load("res://apple.tscn")
	
func body_detected(body: Node3D) -> void:
	if body.name == "Player":
		$Tree/Outline.visible = true
		usable = true
		GameSignals.prompt.emit("hold e for apple")
		
func body_exited(body: Node3D) -> void:
	if body.name == "Player":
		$Tree/Outline.visible = false
		usable = false
		GameSignals.prompt.emit("")

func spawn_apple() -> void:
	var apple: RigidBody3D = apple_scene.instantiate()
	apple_count += 1
	$CanvasLayer/Overlay/AppleCount/VBoxContainer/AppleCount.text = str(apple_count) + " apples"
	$Apples.add_child(apple)
	apple.transform.origin = Vector3(8, 3, 0)
	apple.linear_velocity = Vector3(randf(), 0.1, randf()) * 20

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("interact") and usable:
		spawn_apple()
		
