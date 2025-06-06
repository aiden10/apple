extends Node3D
@onready var stage: Node3D = $Stage
@onready var obstacle_container: Node = $ObstacleContainer
@onready var lava_obstacle1: PackedScene = preload("res://obstacles/lava_obstacle1.tscn")
@onready var obstacles: Array[PackedScene] = [lava_obstacle1]
@onready var rot: Area3D = $Stage/Rot
var obstacle_distance: int = -25

func _ready() -> void:
	for i in range(1):
		spawn_obstacle()
		
	rot.body_entered.connect(func(_body: Node3D): GameSignals.player_death.emit())
	rot.area_entered.connect(func(_area: Area3D): GameSignals.player_death.emit())

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
	stage.global_position.z -= 0.1
	if $Player.global_position.z < obstacle_distance + 75:
		spawn_obstacle()
		
