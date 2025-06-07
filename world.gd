extends Node3D
@onready var stage: Node3D = $Stage
@onready var obstacle_container: Node = $ObstacleContainer
var lava_obstacle1: PackedScene = preload("res://obstacles/lava_obstacle1.tscn")
var moving_platform: PackedScene = preload("res://obstacles/MovingPlatform.tscn")
var doors: PackedScene = preload("res://obstacles/doors_obstacle.tscn")
var obstacles: Array[PackedScene] = [lava_obstacle1, doors, moving_platform]
@onready var rot: Area3D = $Stage/Rot
var obstacle_distance: int = -25

func _ready() -> void:
		
	rot.body_entered.connect(func(body: Node3D):
		if body.name == "Apple" or body.name == "Player":
			GameSignals.player_death.emit()
		)
	GameSignals.restart.connect(restart)

func restart() -> void:
	for child in obstacle_container.get_children():
		child.queue_free()
	$Player.global_position = Vector3(0, 5, 0)
	$Apple.global_position = Vector3(0, 3, -5)
	$Apple.linear_velocity = Vector3.ZERO
	$Apple.angular_velocity = Vector3.ZERO
	stage.global_position = Vector3.ZERO
	obstacle_distance = 25
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func spawn_obstacle() -> void:
	var obstacle_scene: PackedScene = obstacles.pick_random()
	var obstacle: Node3D = obstacle_scene.instantiate()
	obstacle_container.add_child(obstacle)
	obstacle.global_position = Vector3(0, 0, obstacle_distance)
	obstacle_distance -= 50
	for child in obstacle_container.get_children():
		if child.global_position.z - 100 > rot.global_position.z:
			child.queue_free()

func _physics_process(delta: float) -> void:
	stage.global_position.z -= 0.03
	if $Player.global_position.z < obstacle_distance + 75:
		spawn_obstacle()
		
