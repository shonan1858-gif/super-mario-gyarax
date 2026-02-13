extends CharacterBody3D
class_name PlayerController

@export var walk_speed: float = 5.0
@export var dash_speed: float = 9.0
@export var acceleration: float = 20.0
@export var jump_velocity: float = 7.5
@export var floor_snap: float = 0.4
@export var max_fall_speed: float = 35.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var spawn_point: Vector3
var cam_rig: Node3D

func _ready() -> void:
	spawn_point = global_position
	cam_rig = get_tree().get_first_node_in_group("camera_rig") as Node3D
	floor_snap_length = floor_snap
	safe_margin = 0.06
	max_slides = 6
	up_direction = Vector3.UP
	floor_stop_on_slope = true
	floor_block_on_wall = true
	floor_constant_speed = false
	floor_max_angle = deg_to_rad(48.0)
	wall_min_slide_angle = deg_to_rad(15.0)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var world_dir := _to_camera_basis(input_dir)
	var target_speed := dash_speed if Input.is_action_pressed("dash") else walk_speed
	var target_velocity := world_dir * target_speed
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	elif not is_on_floor():
		velocity.y = max(velocity.y - gravity * delta, -max_fall_speed)
	elif velocity.y < 0.0:
		velocity.y = 0.0

	move_and_slide()

func _to_camera_basis(input_dir: Vector2) -> Vector3:
	if input_dir == Vector2.ZERO:
		return Vector3.ZERO
	var basis_node := cam_rig if cam_rig != null else self
	var forward := -basis_node.global_transform.basis.z
	var right := basis_node.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	return (right * input_dir.x + forward * input_dir.y).normalized()

func set_spawn_point(new_spawn: Vector3) -> void:
	spawn_point = new_spawn

func respawn() -> void:
	global_position = spawn_point
	velocity = Vector3.ZERO

func get_horizontal_speed() -> float:
	return Vector2(velocity.x, velocity.z).length()
