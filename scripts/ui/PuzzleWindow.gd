extends Control

var validators := {
	"debug01": preload("res://scripts/puzzles/validators/Debug01Validator.gd"),
	"debug05": preload("res://scripts/puzzles/validators/Debug05Validator.gd"),
}

var active_puzzle: PuzzleBase

@onready var title_label: Label = %TitleLabel
@onready var desc_label: Label = %DescriptionLabel
@onready var input: TextEdit = %AnswerInput
@onready var feedback_label: Label = %FeedbackLabel

func _ready() -> void:
	add_to_group("puzzle_window")
	hide()

func open_puzzle(puzzle_id: String) -> void:
	if not validators.has(puzzle_id):
		push_warning("Unknown puzzle: %s" % puzzle_id)
		return
	active_puzzle = validators[puzzle_id].new()
	title_label.text = active_puzzle.title
	desc_label.text = active_puzzle.description + "\nHint: " + active_puzzle.hint
	input.text = ""
	feedback_label.text = ""
	show()

func _on_run_button_pressed() -> void:
	if active_puzzle == null:
		return
	if active_puzzle.validate(input.text):
		feedback_label.text = "Correct."
		AudioManager.play_sfx("floor_unlock")
		if active_puzzle.puzzle_id == "debug05":
			GameState.unlock_floor3()
		else:
			GameState.increase_code_level()
	else:
		feedback_label.text = "Not quite. Read the hint and try again."

func _on_close_button_pressed() -> void:
	hide()
