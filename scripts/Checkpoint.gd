extends Area3D
class_name Checkpoint

@export var spawn_marker_path: NodePath

@onready var spawn_marker: Node3D = get_node_or_null(spawn_marker_path)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerController:
		var spawn := global_position
		if spawn_marker != null:
			spawn = spawn_marker.global_position
		body.set_spawn_point(spawn)
		var level_manager := get_tree().get_first_node_in_group("level_manager")
		if level_manager != null:
			level_manager.update_checkpoint(spawn)
