extends "res://scripts/objects/Interactable.gd"

@export var fragment_id := ""

func interact(_player: Node) -> void:
	GameState.collect_fragment(fragment_id)
	AudioManager.play_sfx("fragment_found")
	queue_free()
