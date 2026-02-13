extends Node3D
class_name CameraRig

@export var target_path: NodePath
@export var sensitivity: float = 0.003
@export var min_pitch: float = -60.0
@export var max_pitch: float = 35.0
@export var distance: float = 4.5
@export var height_offset: float = 1.6
@export var min_distance: float = 1.0

@onready var yaw_node: Node3D = $Yaw
@onready var pitch_node: Node3D = $Yaw/Pitch
@onready var camera: Camera3D = $Yaw/Pitch/Camera3D

var target: Node3D
var yaw: float = 0.0
var pitch: float = -12.0

func _ready() -> void:
	add_to_group("camera_rig")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if not target_path.is_empty():
		target = get_node_or_null(target_path)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	global_position = target.global_position + Vector3.UP * height_offset
	yaw_node.rotation.y = yaw
	pitch_node.rotation.x = pitch
	_update_camera_distance()

func _update_camera_distance() -> void:
	var desired_local := Vector3(0, 0, distance)
	var from := global_position
	var to := pitch_node.to_global(desired_local)
	var state := get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.exclude = [target]
	var hit := state.intersect_ray(params)
	var dist := distance
	if not hit.is_empty():
		dist = max(min_distance, from.distance_to(hit.position) - 0.2)
	camera.position.z = dist
