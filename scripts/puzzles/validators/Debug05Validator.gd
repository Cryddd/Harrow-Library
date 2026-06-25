extends PuzzleBase

func _init() -> void:
	puzzle_id = "debug05"
	title = "FINAL: Complete the Cognition Module"
	description = "Kai's unfinished AI module needs a forward pass. Implement it to unlock Floor 3."
	hint = "Process input, store result in memory, then return the output."

func validate(answer: String) -> bool:
	var s := normalize(answer)
	return (s.contains("return") and s.contains("input")) or (s.contains("weight") and s.contains("input")) or s.contains("memory.append") or s.contains("output")
