extends "res://scripts/objects/Interactable.gd"

@export var to_floor := 1
@export var locked := false
@export var unlock_flag := ""

func interact(_player: Node) -> void:
	if locked and unlock_flag == "floor3" and not GameState.floor3_is_unlocked:
		print("Floor 3 locked. Complete the investigation first.")
		return
	SceneManager.transition_to_floor(to_floor, get_tree().get_first_node_in_group("world_root"))
