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
	var color := _prop_color(kind)
	var body := _rect_node(rect, color)
	body.name = String(prop.get("id", "Prop"))
	parent.add_child(body)
	_add_prop_collision(prop)
	var top := _rect_node(Rect2(rect.position, Vector2(rect.size.x, maxf(3.0, rect.size.y * 0.16))), color.lightened(0.22))
	parent.add_child(top)
	if kind.contains("screen") or kind.contains("terminal") or kind.contains("workstation") or kind.contains("server"):
		_draw_glow(parent, rect.get_center(), _glow_color(kind), maxf(rect.size.x, rect.size.y) * 0.55)
	if kind.contains("bookshelf") or kind.contains("archive_shelf"):
		_draw_books(parent, rect)
	if kind.contains("whiteboard") or kind == "neural_display":
		_draw_board_marks(parent, rect, kind)

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
