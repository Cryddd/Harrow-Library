extends Node2D

@export var floor_number := 1
@export var floor_name := "Floor"
@export var zones: Array[Dictionary] = []

func _ready() -> void:
	add_to_group("floor")
	_spawn_fragments()
	_spawn_npcs()

func _spawn_fragments() -> void:
	var fragment_scene := preload("res://scenes/objects/Fragment.tscn")
	for fragment in GameState.fragments_data:
		if int(fragment.get("floor", 0)) != floor_number:
			continue
		if GameState.fragments.has(fragment.get("id", "")):
			continue
		var node := fragment_scene.instantiate()
		node.fragment_id = fragment.get("id", "")
		node.global_position = fragment.get("position", Vector2.ZERO)
		$Fragments.add_child(node)

func _spawn_npcs() -> void:
	var npc_scene := preload("res://scenes/characters/NPC.tscn")
	for npc_id in GameState.npc_data.keys():
		var data: Dictionary = GameState.npc_data[npc_id]
		if int(data.get("floor", 0)) != floor_number:
			continue
		if data.get("hidden", false) and not GameState.npc_met_flags.get(npc_id, false):
			continue
		var npc := npc_scene.instantiate()
		npc.npc_id = npc_id
		npc.npc_name = data.get("name", npc_id)
		npc.role = data.get("role", "")
		npc.timeline = data.get("timeline", npc_id)
		npc.global_position = data.get("position", Vector2.ZERO)
		$NPCs.add_child(npc)
