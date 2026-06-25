extends CharacterBody2D

@export var npc_id := ""
@export var npc_name := ""
@export var role := ""
@export var timeline := ""
@export var speed := 70.0
@export var schedule: Array[Dictionary] = []

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $NPCStateMachine

var target_position := Vector2.ZERO

func _ready() -> void:
	add_to_group("npc")
	target_position = global_position
	if state_machine and state_machine.has_method("setup"):
		state_machine.setup(self)

func _physics_process(_delta: float) -> void:
	if GameState.paused:
		return
	_update_schedule_target()
	var delta_pos := target_position - global_position
	if delta_pos.length() > 4.0:
		velocity = delta_pos.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _update_schedule_target() -> void:
	if schedule.is_empty():
		return
	var target := GameClock.get_schedule_target(schedule)
	target_position = target.get("position", global_position)

func interact(_player: Node) -> void:
	GameState.mark_npc_met(npc_id)
	if Engine.has_singleton("Dialogic"):
		Engine.get_singleton("Dialogic").start(timeline)
	else:
		print("%s: Dialogic timeline '%s' requested." % [npc_name, timeline])
