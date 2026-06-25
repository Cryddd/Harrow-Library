extends Control

func _ready() -> void:
	hide()

func open() -> void:
	show()
	GameState.paused = true

func close() -> void:
	hide()
	GameState.paused = false

func _on_resume_button_pressed() -> void:
	close()

func _on_save_button_pressed() -> void:
	SaveSystem.save_game()

func _on_load_button_pressed() -> void:
	if SaveSystem.load_game():
		close()
