extends Control

var settings_open := false

func _ready() -> void:
	_build_menu()

func _build_menu() -> void:
	for child in get_children():
		child.queue_free()
	var bg := ColorRect.new()
	bg.color = Color("090b12")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var glow := ColorRect.new()
	glow.color = Color(0.22, 0.015, 0.035, 0.28)
	glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(glow)
	var title := Label.new()
	title.text = "ПРОКЛЯТЫЙ\nПЛАНШЕТ"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color("e7e8ef"))
	title.anchor_left = 0.1
	title.anchor_right = 0.9
	title.anchor_top = 0.13
	title.anchor_bottom = 0.43
	add_child(title)
	var subtitle := Label.new()
	subtitle.text = "НЕ ВСЁ, ЧТО НА ЭКРАНЕ, ОСТАЁТСЯ ВНУТРИ"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 17)
	subtitle.add_theme_color_override("font_color", Color("a4a7b5"))
	subtitle.anchor_left = 0.08
	subtitle.anchor_right = 0.92
	subtitle.anchor_top = 0.43
	subtitle.anchor_bottom = 0.5
	add_child(subtitle)
	if settings_open:
		_add_button("ГРОМКОСТЬ: 100%", 0.55, func(): pass)
		_add_button("НАЗАД", 0.67, func(): settings_open = false; _build_menu())
	else:
		_add_button("ИГРАТЬ", 0.54, func(): get_tree().change_scene_to_file("res://scenes/room.tscn"))
		_add_button("НАСТРОЙКИ", 0.65, func(): settings_open = true; _build_menu())
		_add_button("ВЫЙТИ", 0.76, func(): get_tree().quit())
	var credit := Label.new()
	credit.text = "GINGERXYT STUDIOS  •  DEMO 0.1"
	credit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credit.add_theme_font_size_override("font_size", 14)
	credit.add_theme_color_override("font_color", Color("666a79"))
	credit.anchor_left = 0.1
	credit.anchor_right = 0.9
	credit.anchor_top = 0.92
	credit.anchor_bottom = 0.98
	add_child(credit)

func _add_button(caption: String, y: float, action: Callable) -> void:
	var button := Button.new()
	button.text = caption
	button.anchor_left = 0.35
	button.anchor_right = 0.65
	button.anchor_top = y
	button.anchor_bottom = y + 0.075
	button.add_theme_font_size_override("font_size", 22)
	button.add_theme_color_override("font_color", Color("f0f0f5"))
	button.add_theme_stylebox_override("normal", _button_style(Color("202431")))
	button.add_theme_stylebox_override("hover", _button_style(Color("52202b")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("7b2635")))
	button.pressed.connect(action)
	add_child(button)

func _button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color("6f3340")
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style