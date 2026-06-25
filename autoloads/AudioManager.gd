extends Node

const SAMPLE_RATE := 44100

var muted := false
var volumes := {
	"master": 0.72,
	"music": 0.55,
	"ambient": 0.40,
	"sfx": 0.65,
}

var _music_player: AudioStreamPlayer
var _ambient_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer

func _ready() -> void:
	_music_player = _make_generator_player("Music")
	_ambient_player = _make_generator_player("Ambient")
	_sfx_player = _make_generator_player("SFX")
	add_child(_music_player)
	add_child(_ambient_player)
	add_child(_sfx_player)

func _make_generator_player(bus_name: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = SAMPLE_RATE
	stream.buffer_length = 0.15
	player.stream = stream
	player.bus = "Master"
	player.name = bus_name
	return player

func set_volume(group: String, value: float) -> void:
	volumes[group] = clampf(value, 0.0, 1.0)

func mute(value: bool) -> void:
	muted = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)

func play_sfx(kind: String) -> void:
	if muted:
		return
	# Placeholder for the HTML procedural SFX port. Each kind maps to a short
	# synthesized blip once the generator buffer writer is completed.
	match kind:
		"fragment_found", "secret_found", "terminal_access", "floor_unlock", "stair", "footstep":
			pass
		_:
			pass

func update_zone(floor: int, position: Vector2) -> void:
	# Port target for the old AUDIO.updateZone(floor, px, py) logic.
	# Floor 1 favors warm study ambience, Floor 2 cool lab drones, Floor 3 tense
	# SYSTEM_7 pulses.
	pass
