extends CharacterBody2D

@export var speed := 170.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $InteractArea

var facing := Vector2.DOWN
var nearby_interactable: Node = null

func _ready() -> void:
	interact_area.area_entered.connect(_on_interact_area_entered)
	interact_area.area_exited.connect(_on_interact_area_exited)

func _physics_process(_delta: float) -> void:
	if GameState.paused:
		velocity = Vector2.ZERO
		return
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * speed
	if input_vector.length() > 0.0:
		facing = input_vector.normalized()
		_play_walk_animation(input_vector)
	else:
		_play_idle_animation()
	move_and_slide()
	GameState.player_position = global_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearby_interactable:
		nearby_interactable.interact(self)

func _play_walk_animation(direction: Vector2) -> void:
	var anim := _direction_to_anim(direction, "walk")
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim):
		animated_sprite.play(anim)

func _play_idle_animation() -> void:
	var anim := _direction_to_anim(facing, "idle")
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim):
		animated_sprite.play(anim)

func _direction_to_anim(direction: Vector2, prefix: String) -> String:
	if absf(direction.x) > absf(direction.y):
		return "%s_right" % prefix if direction.x > 0.0 else "%s_left" % prefix
	return "%s_down" % prefix if direction.y > 0.0 else "%s_up" % prefix

func _on_interact_area_entered(area: Area2D) -> void:
	if area.has_method("interact"):
		nearby_interactable = area

func _on_interact_area_exited(area: Area2D) -> void:
	if nearby_interactable == area:
		nearby_interactable = null
