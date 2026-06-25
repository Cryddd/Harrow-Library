extends StaticBody2D

@export var shelf_id := ""
@export var clue_id := ""

func inspect() -> void:
	if clue_id != "":
		GameState.discovered.append(clue_id)
