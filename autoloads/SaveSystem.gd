extends Node

const SAVE_PATH := "user://harrow_library.cfg"

func save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("game", "floor", GameState.floor)
	cfg.set_value("game", "player_x", GameState.player_position.x)
	cfg.set_value("game", "player_y", GameState.player_position.y)
	cfg.set_value("game", "chapter", GameState.chapter)
	cfg.set_value("game", "code_level", GameState.code_level)
	cfg.set_value("game", "wellbeing", GameState.wellbeing)
	cfg.set_value("game", "floor3_unlocked", GameState.floor3_is_unlocked)
	cfg.set_value("collections", "fragments", GameState.fragments)
	cfg.set_value("collections", "discovered", GameState.discovered)
	cfg.set_value("objectives", "done", GameState.done_objectives)
	cfg.set_value("npcs", "met", GameState.npc_met_flags)
	cfg.set_value("clock", "minutes", int(GameClock.time_minutes))
	var err := cfg.save(SAVE_PATH)
	if err != OK:
		push_error("Failed to save game: %s" % err)

func load_game() -> bool:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return false
	GameState.floor = int(cfg.get_value("game", "floor", 1))
	GameState.player_position = Vector2(
		float(cfg.get_value("game", "player_x", 400.0)),
		float(cfg.get_value("game", "player_y", 340.0))
	)
	GameState.chapter = int(cfg.get_value("game", "chapter", 1))
	GameState.code_level = int(cfg.get_value("game", "code_level", 1))
	GameState.wellbeing = int(cfg.get_value("game", "wellbeing", 100))
	GameState.floor3_is_unlocked = bool(cfg.get_value("game", "floor3_unlocked", false))
	GameState.fragments.assign(cfg.get_value("collections", "fragments", []))
	GameState.discovered.assign(cfg.get_value("collections", "discovered", []))
	GameState.done_objectives.assign(cfg.get_value("objectives", "done", []))
	GameState.npc_met_flags = cfg.get_value("npcs", "met", {})
	GameClock.set_time(int(cfg.get_value("clock", "minutes", 540)))
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
