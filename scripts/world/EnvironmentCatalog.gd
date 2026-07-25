extends RefCounted
class_name EnvironmentCatalog

static func rooms_for_floor(floor: int) -> Array[Dictionary]:
	match floor:
		1:
			return [
				_room("Entry Hall", Rect2(60, 150, 420, 280), Color("#c98754"), Color("#d8a04f"), Color("#54301a")),
				_room("General Stacks", Rect2(60, 470, 420, 380), Color("#b87449"), Color("#d8a04f"), Color("#4a2716")),
				_room("Coding Lab", Rect2(520, 150, 560, 500), Color("#344a5d"), Color("#66d9ff"), Color("#1c2c3c")),
				_room("Collab Zone", Rect2(520, 690, 560, 240), Color("#9a6a45"), Color("#93d78d"), Color("#4f3827")),
				_room("Quiet Study", Rect2(1140, 150, 340, 320), Color("#bd8052"), Color("#f0c56d"), Color("#56331e")),
				_room("Archive Wing", Rect2(1140, 510, 560, 360), Color("#2c1d3e"), Color("#b06aff"), Color("#13091f")),
				_room("Reading Hall", Rect2(60, 900, 1640, 150), Color("#ad7148"), Color("#f0c56d"), Color("#56331e")),
			]
		2:
			return [
				_room("Software Engineering", Rect2(60, 130, 500, 470), Color("#31465b"), Color("#66d9ff"), Color("#1c2c3c")),
				_room("AI Research Lab", Rect2(610, 130, 540, 470), Color("#342f4d"), Color("#b06aff"), Color("#1d1730")),
				_room("Study Lounge", Rect2(1210, 130, 490, 470), Color("#b57649"), Color("#f0c56d"), Color("#5a351f")),
				_room("Project Pit", Rect2(60, 640, 500, 260), Color("#9b6947"), Color("#93d78d"), Color("#4f3827")),
				_room("Presentation Bay", Rect2(610, 640, 540, 260), Color("#283c4f"), Color("#66d9ff"), Color("#18293a")),
				_room("Sealed Server Annex", Rect2(1210, 640, 490, 260), Color("#28183d"), Color("#b06aff"), Color("#12091d")),
			]
		3:
			return [
				_room("Abandoned Lab", Rect2(60, 120, 700, 760), Color("#21152e"), Color("#b06aff"), Color("#0e0716")),
				_room("SYSTEM_7 Core", Rect2(800, 280, 320, 420), Color("#2a1648"), Color("#ff5ee8"), Color("#11051f")),
				_room("Restricted Archive", Rect2(1180, 160, 520, 300), Color("#26153d"), Color("#b06aff"), Color("#10081c")),
				_room("Kai's Workstation", Rect2(1180, 520, 520, 300), Color("#241533"), Color("#b06aff"), Color("#10081c")),
			]
	return []

static func props_for_floor(floor: int) -> Array[Dictionary]:
	match floor:
		1:
			return [
				_prop("reception_counter", Rect2(100, 250, 250, 62), "desk"),
				_prop("digital_directory", Rect2(360, 192, 72, 46), "screen"),
				_prop("university_emblem", Rect2(218, 190, 88, 58), "display"),
				_prop("trophy_case", Rect2(92, 184, 58, 34), "glass"),
				_prop("entry_banner", Rect2(126, 166, 232, 24), "banner"),
				_prop("visitor_bench", Rect2(110, 350, 120, 30), "bench"),
				_prop("campus_kiosk", Rect2(384, 280, 46, 74), "kiosk"),
				_prop("recycling_bin", Rect2(390, 360, 26, 30), "bin"),
				_prop("plant", Rect2(96, 380, 36, 58), "plant"),
				_prop("plant", Rect2(416, 380, 36, 58), "plant"),
				_prop("sun_window_a", Rect2(378, 192, 62, 42), "window"),
				_prop("wall_lamp_entry_a", Rect2(86, 176, 22, 32), "lamp"),
				_prop("wall_lamp_entry_b", Rect2(434, 176, 22, 32), "lamp"),
				_prop("stacks_a", Rect2(86, 542, 74, 254), "bookshelf"),
				_prop("stacks_b", Rect2(178, 542, 74, 254), "bookshelf"),
				_prop("stacks_c", Rect2(270, 542, 74, 254), "bookshelf"),
				_prop("rolling_ladder_general", Rect2(330, 555, 28, 230), "ladder"),
				_prop("catalog_terminal", Rect2(386, 610, 54, 64), "kiosk"),
				_prop("open_book_table", Rect2(96, 470, 180, 58), "table"),
				_prop("stack_corner_chair", Rect2(366, 742, 46, 42), "reading_chair"),
				_prop("live_dashboard", Rect2(560, 192, 318, 56), "screen"),
				_prop("algorithm_board", Rect2(900, 190, 144, 78), "whiteboard"),
				_prop("network_rack", Rect2(1014, 310, 42, 182), "server_rack"),
				_prop("debug_wall", Rect2(552, 276, 430, 28), "debug_wall"),
				_prop("debug_station_1", Rect2(556, 316, 118, 52), "workstation"),
				_prop("debug_station_2", Rect2(704, 316, 118, 52), "workstation"),
				_prop("debug_station_3", Rect2(852, 316, 118, 52), "workstation_error"),
				_prop("debug_station_4", Rect2(556, 430, 118, 52), "workstation"),
				_prop("debug_station_5", Rect2(704, 430, 118, 52), "workstation_warn"),
				_prop("debug_station_6", Rect2(852, 430, 118, 52), "workstation"),
				_prop("debug_station_7", Rect2(556, 544, 118, 52), "workstation"),
				_prop("debug_station_8", Rect2(704, 544, 118, 52), "workstation"),
				_prop("debug_station_9", Rect2(852, 544, 118, 52), "workstation"),
				_prop("brainstorm_table", Rect2(590, 748, 180, 58), "table"),
				_prop("pair_programming_table", Rect2(818, 748, 180, 58), "table"),
				_prop("sticky_note_wall", Rect2(992, 718, 58, 96), "sticky_wall"),
				_prop("charging_bar", Rect2(548, 858, 210, 20), "charging_bar"),
				_prop("collab_rug", Rect2(570, 716, 470, 170), "rug"),
				_prop("study_carrel_a", Rect2(1160, 242, 76, 40), "workstation_dim"),
				_prop("study_carrel_b", Rect2(1260, 242, 76, 40), "workstation_dim"),
				_prop("study_carrel_c", Rect2(1360, 242, 76, 40), "workstation_dim"),
				_prop("quiet_sofa", Rect2(1180, 382, 118, 56), "sofa"),
				_prop("reading_lamp_quiet", Rect2(1408, 360, 28, 58), "floor_lamp"),
				_prop("archive_shelf_a", Rect2(1166, 548, 72, 246), "archive_shelf"),
				_prop("archive_shelf_b", Rect2(1260, 548, 72, 246), "archive_shelf"),
				_prop("archive_shelf_c", Rect2(1354, 548, 72, 246), "archive_shelf"),
				_prop("archive_shelf_d", Rect2(1448, 548, 72, 246), "archive_shelf"),
				_prop("archive_rolling_ladder", Rect2(1516, 552, 30, 240), "ladder"),
				_prop("rare_thesis_case", Rect2(1184, 806, 188, 42), "glass"),
				_prop("archive_c_terminal", Rect2(1564, 554, 68, 90), "system_terminal"),
				_prop("staff_only_door", Rect2(1614, 650, 66, 118), "locked_door"),
				_prop("reading_table_a", Rect2(100, 936, 210, 58), "table"),
				_prop("reading_table_b", Rect2(370, 936, 210, 58), "table"),
				_prop("reading_table_c", Rect2(640, 936, 210, 58), "table"),
				_prop("reading_table_d", Rect2(910, 936, 210, 58), "table"),
				_prop("reading_table_e", Rect2(1180, 936, 210, 58), "table"),
				_prop("reading_table_f", Rect2(1450, 936, 210, 58), "table"),
			]
		2:
			return [
				_prop("software_lab_rows", Rect2(86, 226, 418, 292), "workstation_cluster"),
				_prop("sprint_board", Rect2(82, 534, 210, 64), "whiteboard"),
				_prop("agile_sticky_wall", Rect2(322, 526, 178, 70), "sticky_wall"),
				_prop("printer_station", Rect2(474, 160, 54, 56), "printer"),
				_prop("glass_meeting_room", Rect2(70, 152, 212, 50), "glass_partition"),
				_prop("neural_net_wall", Rect2(632, 174, 268, 94), "neural_display"),
				_prop("gpu_cluster", Rect2(636, 434, 96, 134), "server_rack"),
				_prop("robotics_table", Rect2(890, 246, 238, 292), "research_cluster"),
				_prop("robot_prototype", Rect2(780, 410, 70, 82), "robot"),
				_prop("vr_station", Rect2(1040, 174, 70, 58), "vr_station"),
				_prop("lounge_sofa_a", Rect2(1246, 220, 130, 76), "sofa"),
				_prop("lounge_sofa_b", Rect2(1542, 220, 130, 76), "sofa"),
				_prop("coffee_table", Rect2(1412, 272, 86, 54), "table"),
				_prop("lounge_rug", Rect2(1232, 198, 446, 354), "rug"),
				_prop("water_dispenser", Rect2(1650, 504, 34, 64), "water_dispenser"),
				_prop("campus_awards", Rect2(1510, 152, 136, 48), "display"),
				_prop("project_showcase", Rect2(86, 700, 410, 72), "display_case"),
				_prop("presentation_screen", Rect2(640, 676, 310, 58), "screen"),
				_prop("audience_seats", Rect2(660, 770, 360, 120), "chairs"),
				_prop("presentation_stage", Rect2(620, 646, 520, 28), "stage"),
				_prop("demo_pc_a", Rect2(1112, 724, 42, 68), "kiosk"),
				_prop("final_puzzle_terminal", Rect2(990, 690, 68, 90), "system_terminal"),
				_prop("system7_annex_terminal", Rect2(1634, 700, 68, 90), "system_terminal"),
				_prop("annex_cable_tray", Rect2(1238, 830, 392, 20), "cable_tray"),
			]
		3:
			return [
				_prop("redacted_whiteboard_a", Rect2(82, 210, 310, 66), "whiteboard_redacted"),
				_prop("redacted_whiteboard_b", Rect2(430, 210, 310, 66), "whiteboard_redacted"),
				_prop("dead_terminal_row", Rect2(90, 328, 648, 70), "dead_terminals"),
				_prop("abandoned_desks", Rect2(86, 420, 564, 176), "broken_desks"),
				_prop("scattered_papers", Rect2(110, 630, 520, 74), "paper_field"),
				_prop("emergency_light", Rect2(682, 144, 42, 24), "warning_light"),
				_prop("system7_core", Rect2(870, 410, 200, 180), "core_terminal"),
				_prop("core_cable_ring", Rect2(806, 348, 320, 320), "cable_ring"),
				_prop("restricted_archive_shelves", Rect2(1208, 218, 438, 204), "archive_shelf_cluster"),
				_prop("sealed_vault", Rect2(1622, 232, 58, 166), "locked_door"),
				_prop("kai_desk", Rect2(1218, 592, 260, 74), "desk"),
				_prop("kai_echo_terminal", Rect2(1408, 570, 68, 90), "system_terminal"),
				_prop("memory_notes", Rect2(1228, 688, 222, 68), "paper_field"),
				_prop("broken_lamp", Rect2(1504, 642, 36, 44), "broken_lamp"),
			]
	return []

static func ambient_fx_for_floor(floor: int) -> Array[Dictionary]:
	match floor:
		1:
			return [
				{"kind":"dust","position":Vector2(760, 500), "color":Color("#ffd68066")},
				{"kind":"monitor_cursor","position":Vector2(920, 300), "color":Color("#66d9ff")},
				{"kind":"lamp_flicker","position":Vector2(1560, 600), "color":Color("#b06aff")},
			]
		2:
			return [
				{"kind":"server_leds","position":Vector2(684, 498), "color":Color("#b06aff")},
				{"kind":"hologram","position":Vector2(766, 246), "color":Color("#66d9ff")},
			]
		3:
			return [
				{"kind":"glitch","position":Vector2(960, 510), "color":Color("#ff5ee8")},
				{"kind":"dust","position":Vector2(420, 520), "color":Color("#b06aff55")},
			]
	return []

static func _room(name: String, rect: Rect2, floor: Color, accent: Color, wall: Color) -> Dictionary:
	return {"name":name, "rect":rect, "floor":floor, "accent":accent, "wall":wall}

static func _prop(id: String, rect: Rect2, kind: String) -> Dictionary:
	return {"id":id, "rect":rect, "kind":kind}
