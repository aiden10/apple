extends CharacterBody3D

const SPEED = 10
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 1.5
var jump_velocity: float = 6.5
var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
var TILT_UPPER_LIMIT := deg_to_rad(90.0)
var _mouse_input: bool = false
var _rotation_input: float
var _tilt_input: float
var _mouse_rotation: Vector3
var _player_rotation: Vector3
var _camera_rotation: Vector3
@onready var CAMERA_CONTROLLER: Camera3D = $Camera3D
@onready var spear: StaticBody3D = $Camera3D/Spear
var bullet_scene: PackedScene
var double_jump: bool = true
var can_dash: bool = true
const RAY_LENGTH = 100

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$DashCooldown.timeout.connect(func(): can_dash = true)

func _physics_process(delta):
		
	update_camera(delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		double_jump = true
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y += jump_velocity * ((GameState.jump_inc * GameState.jump_stat) + 1)
		elif not is_on_floor() and double_jump:
			velocity.y += jump_velocity + 3 * ((GameState.jump_inc * GameState.jump_stat) + 1)
			double_jump = false
	
	if Input.is_action_pressed("click"):
		spear.stab()
		
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * ((GameState.speed_inc * GameState.speed_stat) + 1)
		velocity.z = direction.z * SPEED * ((GameState.speed_inc * GameState.speed_stat) + 1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if can_dash and Input.is_action_pressed("dash"):
		input_dir = Input.get_vector("left", "right", "up", "down")
		
		if input_dir != Vector2.ZERO:
			var dash_direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y)
			velocity.x += dash_direction.x * GameState.dash_speed * ((GameState.dash_distance_stat * GameState.dash_dist_inc) + 1)
			velocity.z += dash_direction.z * GameState.dash_speed * ((GameState.dash_distance_stat * GameState.dash_dist_inc) + 1)
		
			can_dash = false
			$DashCooldown.wait_time = 3.0 - (GameState.dash_cooldown_inc * GameState.dash_cooldown_stat)
			$DashCooldown.start()
	
	GameState.player_velocity = velocity
	GameState.dash_time = $DashCooldown.time_left
	move_and_slide()
	var space_state = get_world_3d().direct_space_state
	var cam = $Camera3D
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result:
		GameState.look_position = result["position"]
	
func _input(event: InputEvent) -> void:
	if (Input.mouse_mode != Input.MOUSE_MODE_CAPTURED) and event is InputEventMouseButton: 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * Options.mouse_sens
		_tilt_input = -event.relative.y * Options.mouse_sens
		
func update_camera(delta) -> void:
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0
