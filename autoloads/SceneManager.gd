extends Node

signal transition_started(to_floor: int)
signal transition_finished(to_floor: int)

const FLOOR_SCENES := {
	1: "res://scenes/world/Floor1.tscn",
	2: "res://scenes/world/Floor2.tscn",
	3: "res://scenes/world/Floor3.tscn",
}

var current_floor_node: Node = null

func transition_to_floor(to_floor: int, world_root: Node = null) -> void:
	if to_floor == 3 and not GameState.floor3_is_unlocked:
		return
	if not FLOOR_SCENES.has(to_floor):
		push_warning("Unknown floor: %s" % to_floor)
		return
	emit_signal("transition_started", to_floor)
	GameState.set_floor(to_floor)
	if world_root:
		_load_floor_into(world_root, to_floor)
	emit_signal("transition_finished", to_floor)

func _load_floor_into(world_root: Node, floor: int) -> void:
	if current_floor_node and is_instance_valid(current_floor_node):
		current_floor_node.queue_free()
	var packed := load(FLOOR_SCENES[floor])
	if packed == null:
		push_error("Missing floor scene: %s" % FLOOR_SCENES[floor])
		return
	current_floor_node = packed.instantiate()
	world_root.add_child(current_floor_node)
