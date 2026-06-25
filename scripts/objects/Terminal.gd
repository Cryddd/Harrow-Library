extends "res://scripts/objects/Interactable.gd"

@export var terminal_id := ""
@export var timeline := ""
@export var puzzle_id := ""
@export var requires_floor3_unlocked := false

func interact(_player: Node) -> void:
	if requires_floor3_unlocked and not GameState.floor3_is_unlocked:
		print("Floor 3 is locked.")
		return
	AudioManager.play_sfx("terminal_access")
	if puzzle_id != "":
		get_tree().call_group("puzzle_window", "open_puzzle", puzzle_id)
	elif timeline != "":
		if Engine.has_singleton("Dialogic"):
			Engine.get_singleton("Dialogic").start(timeline)
		else:
			print("Dialogic timeline '%s' requested." % timeline)
