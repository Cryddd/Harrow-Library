extends PuzzleBase

func _init() -> void:
	puzzle_id = "debug01"
	title = "DEBUG: Off-by-One Error"
	description = "Emilio's loop runs 0 to n-1 but should include n. Fix the range call."
	hint = "range(n) gives 0..n-1. You need one more iteration."

func validate(answer: String) -> bool:
	var s := normalize(answer)
	return s.contains("range(n+1)") or s.contains("range(1,n+1)") or s.contains("range(0,n+1)")
