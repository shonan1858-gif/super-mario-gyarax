extends Node
class_name LevelManager

@export var player_path: NodePath
@export var goal_message_path: NodePath
@export var debug_label_path: NodePath
@export var door_path: NodePath
@export var required_keys: int = 3
@export var kill_height: float = -20.0

var key_count := 0
var checkpoint_position := Vector3.ZERO

@onready var player: PlayerController = get_node_or_null(player_path)
@onready var goal_message: Label = get_node_or_null(goal_message_path)
@onready var debug_label: Label = get_node_or_null(debug_label_path)
@onready var door: Door = get_node_or_null(door_path)

func _ready() -> void:
	add_to_group("level_manager")
	if player != null:
		checkpoint_position = player.global_position
		player.set_spawn_point(checkpoint_position)
	if goal_message != null:
		goal_message.visible = false
	_update_ui()

func _physics_process(_delta: float) -> void:
	if player != null and player.global_position.y < kill_height:
		respawn_player()
	_update_ui()

func update_checkpoint(new_point: Vector3) -> void:
	checkpoint_position = new_point
	_update_ui()

func add_key() -> void:
	key_count += 1
	if door != null:
		door.update_lock(key_count)
	_update_ui()

func can_finish() -> bool:
	return key_count >= required_keys

func clear_level() -> void:
	if goal_message != null:
		goal_message.visible = true
		goal_message.text = "CLEAR!"

func respawn_player() -> void:
	if player == null:
		return
	player.global_position = checkpoint_position
	player.velocity = Vector3.ZERO

func apply_damage_and_respawn() -> void:
	respawn_player()

func _update_ui() -> void:
	if debug_label == null or player == null:
		return
	debug_label.text = "Speed: %.2f\nGrounded: %s\nKeys: %d/%d\nRespawn: (%.1f, %.1f, %.1f)" % [
		player.get_horizontal_speed(),
		str(player.is_on_floor()),
		key_count,
		required_keys,
		checkpoint_position.x,
		checkpoint_position.y,
		checkpoint_position.z
	]
