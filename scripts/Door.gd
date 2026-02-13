extends Node3D
class_name Door

@export var required_keys: int = 3
@export var open_height: float = 3.0
@export var open_speed: float = 2.5

@onready var door_mesh: Node3D = $DoorBody

var is_open := false
var closed_y: float

func _ready() -> void:
	closed_y = door_mesh.position.y

func _physics_process(delta: float) -> void:
	var target := closed_y + open_height if is_open else closed_y
	door_mesh.position.y = move_toward(door_mesh.position.y, target, open_speed * delta)

func update_lock(current_keys: int) -> void:
	is_open = current_keys >= required_keys
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = is_open
