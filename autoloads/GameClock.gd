extends Node

signal minute_changed(total_minutes: int, formatted_time: String)

const MINUTES_PER_DAY := 1440

@export var minutes_per_real_second := 2.0

var time_minutes := 540.0
var _last_emitted_minute := -1

func _process(delta: float) -> void:
	if not GameState.running or GameState.paused:
		return
	time_minutes = fmod(time_minutes + delta * minutes_per_real_second, MINUTES_PER_DAY)
	var minute := int(time_minutes)
	if minute != _last_emitted_minute:
		_last_emitted_minute = minute
		emit_signal("minute_changed", minute, format_time())

func format_time() -> String:
	var mins := int(time_minutes)
	var hour := int(mins / 60) % 24
	var minute := mins % 60
	var suffix := "AM" if hour < 12 else "PM"
	var display_hour := hour % 12
	if display_hour == 0:
		display_hour = 12
	return "%d:%02d %s" % [display_hour, minute, suffix]

func get_schedule_target(schedule: Array) -> Dictionary:
	if schedule.is_empty():
		return {}
	var target: Dictionary = schedule[0]
	for item in schedule:
		if time_minutes >= float(item.get("time", 0)):
			target = item
	return target

func set_time(minutes: int) -> void:
	time_minutes = clampi(minutes, 0, MINUTES_PER_DAY - 1)
	_last_emitted_minute = -1
