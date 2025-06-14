extends Node3D
@onready var stage: Node3D = $Stage
@onready var obstacle_container: Node = $ObstacleContainer
var lava_obstacle1: PackedScene = preload("res://obstacles/lava_obstacle1.tscn")
var moving_platform: PackedScene = preload("res://obstacles/moving_platform.tscn")
var doors: PackedScene = preload("res://obstacles/doors_obstacle.tscn")
var coin_formation1: PackedScene = preload("res://obstacles/coin_formation1.tscn")
var coin_formation2: PackedScene = preload("res://obstacles/coin_formation2.tscn")
var hallways: PackedScene = preload("res://obstacles/hallways.tscn")
var moving_death: PackedScene = preload("res://obstacles/moving_death1.tscn")
var coin_towers: PackedScene = preload("res://obstacles/coin_towers.tscn")
var rough: PackedScene = preload("res://obstacles/rough.tscn")
var shop1: PackedScene = preload("res://obstacles/shop1.tscn")
var shop2: PackedScene = preload("res://obstacles/shop2.tscn")
var shop3: PackedScene = preload("res://obstacles/shop3.tscn")

var obstacles: Array[PackedScene] = [
	lava_obstacle1, doors, moving_platform, coin_formation1, coin_formation2, hallways,
	moving_death, coin_towers, rough, shop1, shop2, shop3, moving_platform, lava_obstacle1
]
@onready var rot: Area3D = $Stage/Rot
var obstacle_distance: int = -25

func _ready() -> void:
	rot.body_entered.connect(func(body: Node3D):
		if body.name == "Apple" or body.name == "Player":
			GameSignals.player_death.emit()
		)
	load_effects()
	GameSignals.restart.connect(restart)

func load_effects() -> void:
	$Coin/GPUParticles3D.emitting = true
	get_tree().create_timer(1).timeout.connect($Coin.queue_free)
	$Apple.hit_effect.emitting = true

func restart() -> void:
	for child in obstacle_container.get_children():
		child.queue_free()
	$Player.global_position = Vector3(0, 5, 0)
	$Apple.global_position = Vector3(0, 3, -5)
	$Apple.linear_velocity = Vector3.ZERO
	$Apple.angular_velocity = Vector3.ZERO
	$Player/DashCooldown.stop()
	$Player.can_dash = true
	stage.global_position = Vector3.ZERO
	GameState.rot_speed = 0.03
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
	stage.global_position.z -= GameState.rot_speed
	GameState.rot_position = $Stage/Rot.global_position
	GameState.player_position = $Player.global_position
	if $Player.global_position.z < obstacle_distance + 75:
		spawn_obstacle()
	GameState.rot_speed += delta / 5000
		
