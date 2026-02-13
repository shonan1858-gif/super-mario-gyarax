extends Area3D
class_name CollectibleKey

var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if collected or not (body is PlayerController):
		return
	collected = true
	var manager := get_tree().get_first_node_in_group("level_manager")
	if manager != null:
		manager.add_key()
	queue_free()
