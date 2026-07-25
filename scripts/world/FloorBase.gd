extends Node2D

@export var floor_number := 1
@export var floor_name := "Floor"
@export var zones: Array[Dictionary] = []

func _ready() -> void:
	add_to_group("floor")
	_build_environment()
	_spawn_fragments()
	_spawn_npcs()

func _build_environment() -> void:
	var background := Node2D.new()
	background.name = "GeneratedEnvironment"
	add_child(background)
	move_child(background, 0)
	for room in EnvironmentCatalog.rooms_for_floor(floor_number):
		_draw_room(background, room)
	for prop in EnvironmentCatalog.props_for_floor(floor_number):
		_draw_prop(background, prop)
	for fx in EnvironmentCatalog.ambient_fx_for_floor(floor_number):
		_draw_ambient_fx(background, fx)

func _draw_room(parent: Node2D, room: Dictionary) -> void:
	var rect: Rect2 = room.get("rect", Rect2())
	var shadow := _rect_node(rect.grow(18.0), Color("#050505"))
	parent.add_child(shadow)
	var accent: Color = room.get("accent", Color.WHITE)
	var wall_color: Color = room.get("wall", Color.BLACK)
	var floor_color: Color = room.get("floor", Color("#555555"))
	var trim := _rect_node(rect.grow(10.0), accent.darkened(0.15))
	parent.add_child(trim)
	var wall := _rect_node(rect.grow(5.0), wall_color)
	parent.add_child(wall)
	var floor := _rect_node(rect, floor_color)
	parent.add_child(floor)
	var header := _rect_node(Rect2(rect.position, Vector2(rect.size.x, 32.0)), wall_color.darkened(0.18))
	parent.add_child(header)
	_draw_room_architecture(parent, rect, accent, wall_color)
	var title := Label.new()
	title.text = String(room.get("name", "Room")).to_upper()
	title.position = rect.position + Vector2(18, 10)
	title.add_theme_color_override("font_color", accent)
	parent.add_child(title)
	_draw_floor_lines(parent, rect, floor_color.darkened(0.22))

func _draw_floor_lines(parent: Node2D, rect: Rect2, color: Color) -> void:
	for y in range(int(rect.position.y), int(rect.end.y), 32):
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = color
		line.points = PackedVector2Array([Vector2(rect.position.x, y), Vector2(rect.end.x, y)])
		parent.add_child(line)
	for x in range(int(rect.position.x), int(rect.end.x), 84):
		var line := Line2D.new()
		line.width = 1.0
		line.default_color = color.lightened(0.1)
		line.points = PackedVector2Array([Vector2(x, rect.position.y + 32), Vector2(x, rect.end.y)])
		parent.add_child(line)

func _draw_prop(parent: Node2D, prop: Dictionary) -> void:
	var rect: Rect2 = prop.get("rect", Rect2())
	var kind := String(prop.get("kind", "prop"))
	_draw_prop_shape(parent, rect, kind, String(prop.get("id", "Prop")))
	_add_prop_collision(prop)
	if kind.contains("screen") or kind.contains("terminal") or kind.contains("workstation") or kind.contains("server"):
		_draw_glow(parent, rect.get_center(), _glow_color(kind), maxf(rect.size.x, rect.size.y) * 0.55)
	if kind.contains("bookshelf") or kind.contains("archive_shelf"):
		_draw_books(parent, rect)
	if kind.contains("whiteboard") or kind == "neural_display":
		_draw_board_marks(parent, rect, kind)

func _draw_room_architecture(parent: Node2D, rect: Rect2, accent: Color, wall_color: Color) -> void:
	var pillar_color := wall_color.lightened(0.18)
	for x in [rect.position.x + 18.0, rect.end.x - 34.0]:
		parent.add_child(_rect_node(Rect2(x, rect.position.y + 34.0, 16.0, rect.size.y - 50.0), pillar_color.darkened(0.15)))
		parent.add_child(_rect_node(Rect2(x + 2.0, rect.position.y + 36.0, 4.0, rect.size.y - 54.0), pillar_color.lightened(0.18)))
	for x in range(int(rect.position.x + 72.0), int(rect.end.x - 80.0), 168):
		parent.add_child(_rect_node(Rect2(x, rect.position.y + 9.0, 44.0, 11.0), accent.lightened(0.2)))
		_draw_glow(parent, Vector2(x + 22.0, rect.position.y + 32.0), accent.lightened(0.28), 42.0)

func _draw_prop_shape(parent: Node2D, rect: Rect2, kind: String, id: String) -> void:
	if kind == "rug":
		_draw_rug(parent, rect)
		return
	if kind == "plant":
		_draw_plant(parent, rect)
		return
	if kind == "lamp" or kind == "floor_lamp" or kind == "broken_lamp":
		_draw_lamp(parent, rect, kind)
		return
	if kind == "window":
		_draw_window(parent, rect)
		return
	if kind == "banner":
		_draw_banner(parent, rect)
		return
	if kind == "bench" or kind == "sofa" or kind == "reading_chair" or kind == "chairs":
		_draw_seating(parent, rect, kind)
		return
	if kind == "bookshelf" or kind == "archive_shelf" or kind == "archive_shelf_cluster":
		_draw_shelf_case(parent, rect, kind)
		return
	if kind.contains("workstation") or kind == "workstation_cluster" or kind == "research_cluster":
		_draw_workstations(parent, rect, kind)
		return
	if kind == "screen" or kind == "system_terminal" or kind == "core_terminal" or kind == "dead_terminals" or kind == "kiosk":
		_draw_terminal(parent, rect, kind)
		return
	if kind == "whiteboard" or kind == "whiteboard_redacted" or kind == "neural_display" or kind == "debug_wall" or kind == "sticky_wall":
		_draw_board(parent, rect, kind)
		return
	if kind == "server_rack":
		_draw_server_rack(parent, rect)
		return
	if kind == "glass" or kind == "display" or kind == "display_case" or kind == "glass_partition":
		_draw_display_case(parent, rect, kind)
		return
	if kind == "ladder":
		_draw_ladder(parent, rect)
		return
	if kind == "locked_door":
		_draw_locked_door(parent, rect)
		return
	if kind == "robot":
		_draw_robot(parent, rect)
		return
	if kind == "paper_field":
		_draw_paper_field(parent, rect)
		return
	if kind == "cable_ring" or kind == "cable_tray":
		_draw_cables(parent, rect, kind)
		return
	if kind == "stage":
		_draw_stage(parent, rect)
		return
	if kind == "printer" or kind == "water_dispenser" or kind == "bin" or kind == "charging_bar" or kind == "vr_station" or kind == "warning_light":
		_draw_small_fixture(parent, rect, kind)
		return
	var color := _prop_color(kind)
	var body := _rect_node(rect, color)
	body.name = id
	parent.add_child(body)
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, maxf(3.0, rect.size.y * 0.16))), color.lightened(0.22)))

func _draw_books(parent: Node2D, rect: Rect2) -> void:
	var colors := [Color("#c94b3b"), Color("#2f7db8"), Color("#40a35d"), Color("#d19b35"), Color("#8c5cc4"), Color("#24b5a6")]
	for shelf_y in range(int(rect.position.y + 20), int(rect.end.y - 10), 54):
		var shelf := _rect_node(Rect2(rect.position.x + 4, shelf_y, rect.size.x - 8, 5), Color("#3a1d0f"))
		parent.add_child(shelf)
		var x := rect.position.x + 8
		var idx := 0
		while x < rect.end.x - 10:
			var w := 5 + (idx % 4)
			var h := 18 + ((idx * 3) % 18)
			var book := _rect_node(Rect2(x, shelf_y - h, w, h), colors[idx % colors.size()])
			parent.add_child(book)
			x += w + 3
			idx += 1

func _draw_shelf_case(parent: Node2D, rect: Rect2, kind: String) -> void:
	var wood := Color("#3a1d0f") if not kind.contains("archive") else Color("#241020")
	parent.add_child(_rect_node(rect, wood.darkened(0.08)))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(4, 4), rect.size - Vector2(8, 8)), wood))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, 5)), wood.lightened(0.22)))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x - 5, 0), Vector2(5, rect.size.y)), wood.darkened(0.35)))

func _draw_rug(parent: Node2D, rect: Rect2) -> void:
	var base := Color("#5a3b28")
	parent.add_child(_rect_node(rect, base))
	parent.add_child(_rect_node(rect.grow(-8.0), base.lightened(0.18)))
	parent.add_child(_rect_node(rect.grow(-18.0), base.darkened(0.08)))

func _draw_plant(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.25, rect.size.y * 0.62), Vector2(rect.size.x * 0.5, rect.size.y * 0.32)), Color("#8b2e24")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.18, rect.size.y * 0.58), Vector2(rect.size.x * 0.64, 5)), Color("#5f201a")))
	for i in range(7):
		var leaf := Polygon2D.new()
		var cx := rect.position.x + rect.size.x * (0.5 + (i - 3) * 0.07)
		var cy := rect.position.y + rect.size.y * (0.45 - abs(i - 3) * 0.035)
		leaf.polygon = PackedVector2Array([
			Vector2(cx, cy - 22),
			Vector2(cx + 8 + (i % 2) * 5, cy),
			Vector2(cx, cy + 18),
			Vector2(cx - 8 - ((i + 1) % 2) * 5, cy),
		])
		leaf.color = Color("#3fa657").darkened(0.08 * float(i % 3))
		parent.add_child(leaf)

func _draw_lamp(parent: Node2D, rect: Rect2, kind: String) -> void:
	var warm := Color("#ffd36a")
	if kind == "broken_lamp":
		warm = Color("#a37a4a")
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.45, rect.size.y * 0.35), Vector2(4, rect.size.y * 0.5)), Color("#2b2118")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.25, rect.size.y * 0.82), Vector2(rect.size.x * 0.5, 5)), Color("#2b2118")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.12, rect.size.y * 0.16), Vector2(rect.size.x * 0.76, rect.size.y * 0.22)), warm.darkened(0.35)))
	_draw_glow(parent, rect.position + Vector2(rect.size.x * 0.5, rect.size.y * 0.42), warm, rect.size.y)

func _draw_window(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(rect, Color("#2d5c83")))
	parent.add_child(_rect_node(rect.grow(-5.0), Color("#9bd3ff")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(8, rect.size.y - 16), Vector2(rect.size.x - 16, 10)), Color("#55a968")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(10, 8), Vector2(4, rect.size.y - 16)), Color("#ffffff88")))
	_draw_glow(parent, rect.get_center() + Vector2(0, 34), Color("#ffe0a066"), rect.size.x * 0.85)

func _draw_banner(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(rect, Color("#4b1f23")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(8, 5), Vector2(rect.size.x - 16, 4)), Color("#d8a04f")))
	for i in range(4):
		parent.add_child(_rect_node(Rect2(rect.position + Vector2(18 + i * 46, 12), Vector2(28, 6)), Color("#f0c56d").darkened(0.1 * i)))

func _draw_seating(parent: Node2D, rect: Rect2, kind: String) -> void:
	var col := Color("#4c6f54") if kind == "sofa" else Color("#6d4429")
	if kind == "chairs":
		for x in range(int(rect.position.x), int(rect.end.x), 54):
			for y in range(int(rect.position.y), int(rect.end.y), 46):
				_draw_seating(parent, Rect2(x, y, 34, 28), "bench")
		return
	parent.add_child(_rect_node(rect, col))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, rect.size.y * 0.28)), col.lightened(0.18)))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(4, rect.size.y - 6), Vector2(rect.size.x - 8, 6)), col.darkened(0.32)))
	if kind == "sofa":
		for x in [rect.position.x + rect.size.x / 3.0, rect.position.x + rect.size.x * 2.0 / 3.0]:
			parent.add_child(_rect_node(Rect2(x, rect.position.y + 4, 3, rect.size.y - 12), col.darkened(0.22)))

func _draw_workstations(parent: Node2D, rect: Rect2, kind: String) -> void:
	if kind == "workstation_cluster":
		for x in range(int(rect.position.x), int(rect.end.x - 118), 148):
			for y in range(int(rect.position.y), int(rect.end.y - 52), 110):
				_draw_workstations(parent, Rect2(x, y, 118, 52), "workstation")
		return
	if kind == "research_cluster":
		_draw_workstations(parent, Rect2(rect.position, Vector2(112, 52)), "workstation")
		_draw_workstations(parent, Rect2(rect.position + Vector2(126, 0), Vector2(112, 52)), "workstation")
		_draw_tabletop(parent, Rect2(rect.position + Vector2(10, 112), Vector2(rect.size.x - 20, 76)), Color("#53341f"))
		_draw_robot(parent, Rect2(rect.position + Vector2(78, 126), Vector2(62, 68)))
		return
	_draw_tabletop(parent, rect, Color("#203248"))
	var screen_rect := Rect2(rect.position + Vector2(18, -24), Vector2(36, 32))
	var screen_color := _glow_color(kind)
	parent.add_child(_rect_node(screen_rect, Color("#111722")))
	parent.add_child(_rect_node(screen_rect.grow(-4.0), screen_color.darkened(0.55)))
	for i in range(3):
		parent.add_child(_rect_node(Rect2(screen_rect.position + Vector2(7, 7 + i * 7), Vector2(20 + i * 4, 2)), screen_color))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(8, rect.size.y - 16), Vector2(66, 10)), Color("#111722")))
	for i in range(9):
		parent.add_child(_rect_node(Rect2(rect.position + Vector2(12 + i * 6, rect.size.y - 13), Vector2(3, 2)), Color("#66d9ff66")))
	if kind.contains("dim"):
		parent.add_child(_rect_node(screen_rect.grow(-4.0), Color("#101820aa")))

func _draw_tabletop(parent: Node2D, rect: Rect2, color: Color) -> void:
	parent.add_child(_rect_node(rect, color.darkened(0.08)))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, maxf(5.0, rect.size.y * 0.18))), color.lightened(0.22)))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x - 5, 0), Vector2(5, rect.size.y)), color.darkened(0.3)))
	_draw_table_props(parent, rect)

func _draw_table_props(parent: Node2D, rect: Rect2) -> void:
	var colors := [Color("#c94b3b"), Color("#2f7db8"), Color("#40a35d"), Color("#d19b35")]
	for i in range(3):
		parent.add_child(_rect_node(Rect2(rect.position + Vector2(12 + i * 14, 10), Vector2(10, 24)), colors[i % colors.size()])))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x - 60, 10), Vector2(42, 28)), Color("#dfd6bd")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x - 48, 17), Vector2(22, 2)), Color("#7b6a52")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.55, 12), Vector2(12, 12)), Color("#2b6f69")))

func _draw_terminal(parent: Node2D, rect: Rect2, kind: String) -> void:
	if kind == "dead_terminals":
		for x in range(int(rect.position.x), int(rect.end.x - 68), 108):
			_draw_terminal(parent, Rect2(x, rect.position.y, 68, 62), "system_terminal")
		return
	var frame := Color("#111722") if kind != "core_terminal" else Color("#150622")
	parent.add_child(_rect_node(rect, frame))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(5, 5), rect.size - Vector2(10, 24)), _glow_color(kind).darkened(0.62)))
	for i in range(4):
		parent.add_child(_rect_node(Rect2(rect.position + Vector2(10, 14 + i * 10), Vector2(rect.size.x * (0.42 + i * 0.08), 2)), _glow_color(kind)))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.4, rect.size.y - 16), Vector2(rect.size.x * 0.2, 8)), frame.lightened(0.15)))
	if kind == "core_terminal":
		parent.add_child(_rect_node(rect.grow(12.0), Color("#b06aff22")))

func _draw_board(parent: Node2D, rect: Rect2, kind: String) -> void:
	var base := Color("#d9d6c2")
	if kind == "neural_display" or kind == "debug_wall":
		base = Color("#13283a")
	if kind == "sticky_wall":
		base = Color("#5c4731")
	parent.add_child(_rect_node(rect, base))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, 5)), Color("#6c3f22")))
	if kind == "sticky_wall":
		var cols := [Color("#f0c56d"), Color("#66d9ff"), Color("#93d78d"), Color("#e87969")]
		for i in range(20):
			parent.add_child(_rect_node(Rect2(rect.position + Vector2(8 + (i % 6) * 24, 10 + int(i / 6) * 18), Vector2(14, 10)), cols[i % cols.size()])))
	else:
		_draw_board_marks(parent, rect, kind)

func _draw_server_rack(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(rect, Color("#10131f")))
	for y in range(int(rect.position.y + 8), int(rect.end.y - 8), 14):
		parent.add_child(_rect_node(Rect2(rect.position.x + 8, y, rect.size.x - 16, 8), Color("#27283a")))
		parent.add_child(_rect_node(Rect2(rect.end.x - 20, y + 2, 5, 4), Color("#93d78d")))
		parent.add_child(_rect_node(Rect2(rect.end.x - 12, y + 2, 5, 4), Color("#66d9ff")))

func _draw_display_case(parent: Node2D, rect: Rect2, kind: String) -> void:
	parent.add_child(_rect_node(rect, Color("#6c3f22")))
	parent.add_child(_rect_node(rect.grow(-5.0), Color("#9bd3ff44")))
	if kind == "glass_partition":
		for x in range(int(rect.position.x + 24), int(rect.end.x), 48):
			parent.add_child(_rect_node(Rect2(x, rect.position.y, 3, rect.size.y), Color("#ffffff55")))
	else:
		for i in range(3):
			parent.add_child(_rect_node(Rect2(rect.position + Vector2(12 + i * 28, 14), Vector2(14, 16)), Color("#f0c56d")))

func _draw_ladder(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(Rect2(rect.position.x + 4, rect.position.y, 4, rect.size.y), Color("#8f5a32")))
	parent.add_child(_rect_node(Rect2(rect.end.x - 8, rect.position.y, 4, rect.size.y), Color("#8f5a32")))
	for y in range(int(rect.position.y + 12), int(rect.end.y - 4), 24):
		parent.add_child(_rect_node(Rect2(rect.position.x + 5, y, rect.size.x - 10, 4), Color("#c98754")))

func _draw_locked_door(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(rect, Color("#13091f")))
	parent.add_child(_rect_node(rect.grow(-6.0), Color("#241033")))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, 5)), Color("#b06aff")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.65, rect.size.y * 0.45), Vector2(8, 12)), Color("#d8a04f")))

func _draw_robot(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.2, rect.size.y * 0.28), Vector2(rect.size.x * 0.6, rect.size.y * 0.44)), Color("#bcc8c8")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.32, rect.size.y * 0.12), Vector2(rect.size.x * 0.36, rect.size.y * 0.2)), Color("#7f8c98")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.34, rect.size.y * 0.42), Vector2(6, 6)), Color("#66d9ff")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.58, rect.size.y * 0.42), Vector2(6, 6)), Color("#66d9ff")))
	parent.add_child(_rect_node(Rect2(rect.position + Vector2(rect.size.x * 0.1, rect.size.y * 0.78), Vector2(rect.size.x * 0.8, 5)), Color("#1d2430")))

func _draw_paper_field(parent: Node2D, rect: Rect2) -> void:
	for i in range(18):
		var x := rect.position.x + float((i * 37) % int(rect.size.x - 24))
		var y := rect.position.y + float((i * 19) % int(rect.size.y - 16))
		parent.add_child(_rect_node(Rect2(x, y, 22, 14), Color("#dfd6bd").darkened(0.04 * float(i % 3))))

func _draw_cables(parent: Node2D, rect: Rect2, kind: String) -> void:
	var count := 6 if kind == "cable_ring" else 4
	for i in range(count):
		var line := Line2D.new()
		line.width = 3.0
		line.default_color = Color("#0b0712")
		var y := rect.position.y + 10 + i * maxf(8.0, rect.size.y / float(count + 1))
		line.points = PackedVector2Array([Vector2(rect.position.x + 8, y), Vector2(rect.get_center().x, y + sin(float(i)) * 26.0), Vector2(rect.end.x - 8, y + 8)])
		parent.add_child(line)

func _draw_stage(parent: Node2D, rect: Rect2) -> void:
	parent.add_child(_rect_node(rect, Color("#6c3f22")))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, 6)), Color("#d8a04f")))
	for x in range(int(rect.position.x + 24), int(rect.end.x), 72):
		parent.add_child(_rect_node(Rect2(x, rect.position.y + 8, 36, 8), Color("#4b2a18")))

func _draw_small_fixture(parent: Node2D, rect: Rect2, kind: String) -> void:
	var col := Color("#6c3f22")
	if kind == "printer":
		col = Color("#c8c8bc")
	if kind == "water_dispenser":
		col = Color("#8fcce0")
	if kind == "bin":
		col = Color("#347d59")
	if kind == "warning_light":
		col = Color("#ff4b5c")
	parent.add_child(_rect_node(rect, col.darkened(0.12)))
	parent.add_child(_rect_node(Rect2(rect.position, Vector2(rect.size.x, maxf(4.0, rect.size.y * 0.18))), col.lightened(0.2)))
	if kind == "warning_light":
		_draw_glow(parent, rect.get_center(), col, 70.0)

func _draw_board_marks(parent: Node2D, rect: Rect2, kind: String) -> void:
	var mark_color := Color("#1b2b3a") if not kind.contains("redacted") else Color("#9d2631")
	for i in range(4):
		var mark := Line2D.new()
		mark.width = 2.0
		mark.default_color = mark_color
		var y := rect.position.y + 14 + i * 10
		mark.points = PackedVector2Array([Vector2(rect.position.x + 12, y), Vector2(rect.position.x + rect.size.x * (0.45 + i * 0.08), y + (i % 2) * 4)])
		parent.add_child(mark)

func _draw_ambient_fx(parent: Node2D, fx: Dictionary) -> void:
	_draw_glow(parent, fx.get("position", Vector2.ZERO), fx.get("color", Color.WHITE), 72.0)

func _add_prop_collision(prop: Dictionary) -> void:
	var kind := String(prop.get("kind", "prop"))
	if kind.contains("plant") or kind.contains("screen") or kind.contains("display") or kind.contains("glass"):
		return
	var rect: Rect2 = prop.get("rect", Rect2())
	var body := StaticBody2D.new()
	body.name = "%sCollision" % String(prop.get("id", "Prop")).to_pascal_case()
	body.position = rect.get_center()
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)
	$Objects.add_child(body)

func _draw_glow(parent: Node2D, center: Vector2, color: Color, radius: float) -> void:
	var glow := PointLight2D.new()
	glow.position = center
	glow.color = color
	glow.energy = 0.45
	glow.texture_scale = radius / 64.0
	parent.add_child(glow)

func _prop_color(kind: String) -> Color:
	if kind.contains("terminal") or kind.contains("server"):
		return Color("#151826")
	if kind.contains("workstation"):
		return Color("#203248")
	if kind.contains("bookshelf") or kind.contains("archive_shelf"):
		return Color("#3a1d0f")
	if kind.contains("whiteboard") or kind == "neural_display":
		return Color("#d9d6c2")
	if kind.contains("plant"):
		return Color("#357a42")
	if kind.contains("door"):
		return Color("#13091f")
	if kind.contains("sofa"):
		return Color("#4c6f54")
	return Color("#6c3f22")

func _glow_color(kind: String) -> Color:
	if kind.contains("system") or kind.contains("server") or kind.contains("core"):
		return Color("#b06aff")
	if kind.contains("error"):
		return Color("#ff4b5c")
	if kind.contains("warn"):
		return Color("#ffb347")
	return Color("#66d9ff")

func _rect_node(rect: Rect2, color: Color) -> Polygon2D:
	var node := Polygon2D.new()
	node.polygon = PackedVector2Array([
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y),
	])
	node.color = color
	return node

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
