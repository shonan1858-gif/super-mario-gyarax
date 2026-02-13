extends AnimatableBody3D
class_name MovingPlatform

@export var point_a: Vector3 = Vector3.ZERO
@export var point_b: Vector3 = Vector3(0, 0, 6)
@export var speed: float = 2.0

var moving_to_b := true

func _ready() -> void:
	global_position = point_a

func _physics_process(delta: float) -> void:
	var target := point_b if moving_to_b else point_a
	global_position = global_position.move_toward(target, speed * delta)
	if global_position.distance_to(target) < 0.05:
		moving_to_b = not moving_to_b
