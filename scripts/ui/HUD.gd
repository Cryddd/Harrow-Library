extends Control

@onready var chapter_label: Label = %ChapterLabel
@onready var floor_label: Label = %FloorLabel
@onready var time_label: Label = %TimeLabel
@onready var code_label: Label = %CodeLabel
@onready var fragments_label: Label = %FragmentsLabel
@onready var focus_label: Label = %FocusLabel
@onready var objective_list: VBoxContainer = %ObjectiveList

func _ready() -> void:
	GameClock.minute_changed.connect(_on_minute_changed)
	GameState.objective_changed.connect(_on_objective_changed)
	GameState.fragment_collected.connect(_on_fragment_collected)
	GameState.code_level_changed.connect(_on_code_level_changed)
	GameState.wellbeing_changed.connect(_on_wellbeing_changed)
	set_floor(GameState.floor)
	_refresh_stats()
	_on_objective_changed(GameState.objectives, GameState.done_objectives)

func set_floor(floor: int) -> void:
	floor_label.text = "FLOOR %d / 3" % floor

func _on_minute_changed(_total_minutes: int, formatted_time: String) -> void:
	time_label.text = formatted_time

func _on_objective_changed(objectives: Array, done: Array) -> void:
	for child in objective_list.get_children():
		child.queue_free()
	for objective in objectives:
		var label := Label.new()
		label.text = ("✓ " if done.has(objective) else "• ") + objective
		objective_list.add_child(label)

func _on_fragment_collected(_fragment_id: String, _fragment: Dictionary) -> void:
	_refresh_stats()

func _on_code_level_changed(_level: int) -> void:
	_refresh_stats()

func _on_wellbeing_changed(_value: int) -> void:
	_refresh_stats()

func _refresh_stats() -> void:
	chapter_label.text = "Chapter %d: Orientation" % GameState.chapter
	code_label.text = "CODE %d" % GameState.code_level
	fragments_label.text = "FRAGS %d/12" % GameState.fragments.size()
	focus_label.text = "FOCUS %d" % GameState.wellbeing
