extends Node2D

@onready var world_root: Node2D = $WorldRoot
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	GameState.reset_run()
	SceneManager.transition_to_floor(1, world_root)
	GameState.floor_changed.connect(_on_floor_changed)
	SceneManager.transition_finished.connect(_on_transition_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		GameState.paused = not GameState.paused
		get_tree().paused = GameState.paused
	if event.is_action_pressed("files"):
		get_tree().call_group("files_panel", "toggle")

func _on_floor_changed(floor: int) -> void:
	if has_node("UI/HUD"):
		$UI/HUD.set_floor(floor)

func _on_transition_finished(floor: int) -> void:
	var spawn := Vector2(400, 340)
	match floor:
		1:
			spawn = Vector2(1490, 320) if GameState.player_position.x > 1000 else Vector2(400, 340)
		2:
			spawn = Vector2(170, 600)
		3:
			spawn = Vector2(170, 780)
	player.global_position = spawn
	GameState.player_position = spawn
