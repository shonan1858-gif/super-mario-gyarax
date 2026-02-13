extends Area3D
class_name Goal

@export var require_keys: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not (body is PlayerController):
		return
	var manager := get_tree().get_first_node_in_group("level_manager")
	if manager == null:
		return
	if require_keys and not manager.can_finish():
		return
	manager.clear_level()
