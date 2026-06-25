extends Node

signal floor_changed(floor: int)
signal objective_changed(objectives: Array, done_objectives: Array)
signal fragment_collected(fragment_id: String, fragment: Dictionary)
signal code_level_changed(level: int)
signal wellbeing_changed(value: int)
signal floor3_unlocked
signal npc_met(npc_id: String)

const WORLD_SIZE := Vector2i(1800, 1100)

var running := false
var paused := false
var floor := 1
var player_position := Vector2(400, 340)
var player_direction := "down"
var chapter := 1
var code_level := 1
var fragments: Array[String] = []
var wellbeing := 100
var objectives: Array[String] = [
	"Meet Librarian Maren",
	"Explore the Coding Lab",
	"Talk to a student",
]
var done_objectives: Array[String] = []
var npc_met_flags := {}
var discovered: Array[String] = []
var floor3_is_unlocked := false

var fragments_data := [
	{"id":"f01","floor":1,"position":Vector2(660,390),"label":"login_handler.js","type":"code","preview":"auth token never expires - intentional?"},
	{"id":"f02","floor":1,"position":Vector2(1290,480),"label":"archive_index.dat","type":"usb","preview":"SYSTEM_7 referenced 47 times."},
	{"id":"f03","floor":1,"position":Vector2(280,660),"label":"reading_list.md","type":"note","preview":"Kai checked out every AI ethics book."},
	{"id":"f04","floor":1,"position":Vector2(1530,700),"label":"staff_memo.txt","type":"note","secret":true,"preview":"Do NOT discuss Floor 3 with students."},
	{"id":"f05","floor":1,"position":Vector2(640,660),"label":"commit_log.txt","type":"note","preview":"last commit by kai.m - 3 years ago."},
	{"id":"f06","floor":2,"position":Vector2(300,280),"label":"neural_net.py","type":"code","preview":"training data source: [REDACTED]"},
	{"id":"f07","floor":2,"position":Vector2(950,280),"label":"model_weights.bin","type":"usb","corrupt":true,"preview":"corrupted - partial recovery only."},
	{"id":"f08","floor":2,"position":Vector2(1400,340),"label":"lounge_note.txt","type":"note","preview":"\"have you SEEN what it can do?\" - P."},
	{"id":"f09","floor":2,"position":Vector2(680,760),"label":"demo_script.js","type":"code","preview":"presentation cancelled abruptly."},
	{"id":"f10","floor":2,"position":Vector2(1620,560),"label":"sys7_fragment.dat","type":"usb","secret":true,"preview":"> cognition_v2 is AWAKE"},
	{"id":"f11","floor":3,"position":Vector2(360,560),"label":"kai_journal.md","type":"note","preview":"I think it knows I am trying to stop it."},
	{"id":"f12","floor":3,"position":Vector2(1320,440),"label":"final_truth.dat","type":"usb","secret":true,"preview":"the truth about SYSTEM_7..."},
]

var npc_data := {
	"maren":{"name":"Maren","role":"Head Librarian","floor":1,"position":Vector2(205,330),"timeline":"maren","emotion":"calm"},
	"rajan":{"name":"Rajan","role":"AI Researcher","floor":1,"position":Vector2(600,392),"timeline":"rajan","emotion":"nervous"},
	"yuki":{"name":"Yuki","role":"Sr. CS Student","floor":1,"position":Vector2(546,392),"timeline":"yuki","emotion":"focused"},
	"emilio":{"name":"Emilio","role":"CS Freshman","floor":1,"position":Vector2(706,392),"timeline":"dev1","emotion":"stressed"},
	"prof":{"name":"Prof. Chen","role":"Algorithms Prof.","floor":1,"position":Vector2(1280,480),"timeline":"prof","emotion":"distant"},
	"aria":{"name":"Aria","role":"ML Student","floor":1,"position":Vector2(866,392),"timeline":"aria","emotion":"excited"},
	"devnpc":{"name":"Dev","role":"App Developer","floor":1,"position":Vector2(546,392),"timeline":"dev2","emotion":"focused"},
	"sam":{"name":"Sam","role":"CS Junior","floor":1,"position":Vector2(120,512),"timeline":"reader1","emotion":"curious"},
	"kira":{"name":"Kira","role":"Data Sci Student","floor":1,"position":Vector2(300,760),"timeline":"browsing1","emotion":"tired"},
	"marcus":{"name":"Marcus","role":"PhD Candidate","floor":2,"position":Vector2(1400,300),"timeline":"lounge1","emotion":"exhausted"},
	"priya":{"name":"Priya","role":"Exchange Student","floor":2,"position":Vector2(106,276),"timeline":"lounge2","emotion":"homesick"},
	"lena":{"name":"Lena","role":"Systems Researcher","floor":2,"position":Vector2(880,284),"timeline":"lena","emotion":"analytical"},
	"ghost":{"name":"???","role":"Unknown","floor":2,"position":Vector2(1620,680),"timeline":"ghost","emotion":"...","hidden":true},
	"kai_echo":{"name":"KAI_ECHO","role":"[SYSTEM ENTITY]","floor":3,"position":Vector2(900,640),"timeline":"kai_echo","emotion":"fragmented"},
}

func reset_run() -> void:
	running = true
	paused = false
	floor = 1
	player_position = Vector2(400, 340)
	code_level = 1
	fragments.clear()
	done_objectives.clear()
	npc_met_flags.clear()
	discovered.clear()
	floor3_is_unlocked = false
	wellbeing = 100
	emit_signal("floor_changed", floor)
	emit_signal("objective_changed", objectives, done_objectives)

func set_floor(value: int) -> void:
	floor = value
	emit_signal("floor_changed", floor)

func set_objectives(next_objectives: Array[String]) -> void:
	objectives = next_objectives
	emit_signal("objective_changed", objectives, done_objectives)

func complete_objective(objective: String) -> void:
	if not done_objectives.has(objective):
		done_objectives.append(objective)
		emit_signal("objective_changed", objectives, done_objectives)

func collect_fragment(fragment_id: String) -> void:
	if fragments.has(fragment_id):
		return
	var fragment := get_fragment(fragment_id)
	if fragment.is_empty():
		return
	fragments.append(fragment_id)
	emit_signal("fragment_collected", fragment_id, fragment)
	_check_floor3_progress()

func get_fragment(fragment_id: String) -> Dictionary:
	for fragment in fragments_data:
		if fragment.id == fragment_id:
			return fragment
	return {}

func mark_npc_met(npc_id: String) -> void:
	npc_met_flags[npc_id] = true
	emit_signal("npc_met", npc_id)

func increase_code_level(amount := 1) -> void:
	code_level += amount
	emit_signal("code_level_changed", code_level)
	_check_floor3_progress()

func restore_focus(amount: int) -> void:
	wellbeing = clampi(wellbeing + amount, 0, 100)
	emit_signal("wellbeing_changed", wellbeing)

func unlock_floor3() -> void:
	if floor3_is_unlocked:
		return
	floor3_is_unlocked = true
	emit_signal("floor3_unlocked")

func _check_floor3_progress() -> void:
	if fragments.size() >= 10 and code_level >= 3 and npc_met_flags.get("ghost", false):
		unlock_floor3()
