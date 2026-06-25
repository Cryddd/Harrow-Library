extends Node

enum State { IDLE, WALKING, TYPING, READING, TALKING }

var owner_npc: CharacterBody2D
var state := State.IDLE

func setup(npc: CharacterBody2D) -> void:
	owner_npc = npc

func set_state(next_state: State) -> void:
	if state == next_state:
		return
	state = next_state

func update_from_activity(activity: String) -> void:
	match activity:
		"typing":
			set_state(State.TYPING)
		"reading":
			set_state(State.READING)
		"talking":
			set_state(State.TALKING)
		_:
			set_state(State.IDLE)
