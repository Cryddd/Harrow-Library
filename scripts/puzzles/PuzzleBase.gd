extends Resource
class_name PuzzleBase

@export var puzzle_id := ""
@export var title := ""
@export_multiline var description := ""
@export_multiline var code := ""
@export var hint := ""

func validate(_answer: String) -> bool:
	return false

func normalize(answer: String) -> String:
	return answer.to_lower().replace(" ", "").replace("\n", "").replace("\t", "")
