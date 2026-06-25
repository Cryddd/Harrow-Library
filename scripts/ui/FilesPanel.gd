extends Control

@onready var list: VBoxContainer = %FilesList

func _ready() -> void:
	add_to_group("files_panel")
	hide()

func toggle() -> void:
	visible = not visible
	if visible:
		refresh()

func refresh() -> void:
	for child in list.get_children():
		child.queue_free()
	for fragment_id in GameState.fragments:
		var fragment := GameState.get_fragment(fragment_id)
		var label := Label.new()
		label.text = "%s - %s" % [fragment.get("label", fragment_id), fragment.get("preview", "")]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		list.add_child(label)
