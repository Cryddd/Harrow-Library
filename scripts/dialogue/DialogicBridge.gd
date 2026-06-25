extends Node

func start_timeline(timeline: String) -> void:
	if Engine.has_singleton("Dialogic"):
		Engine.get_singleton("Dialogic").start(timeline)
	else:
		push_warning("Dialogic 2 plugin is not installed. Requested timeline: %s" % timeline)
