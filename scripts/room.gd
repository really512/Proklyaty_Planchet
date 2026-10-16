extends Node3D

var player: Node3D
var camera: Camera3D
var status_label: Label
var flicker_timer := 0.0
var elapsed := 0.0
var light: OmniLight3D
var move_dir := Vector2.ZERO

func _ready() -> void:
	_build_room()
	_build_ui()

func _build_room() -> void:
	var floor_mat := _mat(Color("34323a"))
	var wall_mat := _mat(Color("77717a"))
	var dark_mat := _mat(Color("24212b"))
	var wood_mat := _mat(Color("593d31"))
	var cloth_mat := _mat(Color("343d56"))
	_add_box("Floor", Vector3(0, -0.15, 0), Vector3(10, 0.3, 10), floor_mat)
	_add_box("Back wall", Vector3(0, 2.0, -5), Vector3(10, 4, 0.2), wall_mat)
	_add_box("Left wall", Vector3(-5, 2.0, 0), Vector3(0.2, 4, 10), wall_mat)
	_add_box("Right wall", Vector3(5, 2.0, 0), Vector3(0.2, 4, 10), wall_mat)
	_add_box("Ceiling", Vector3(0, 4.1, 0), Vector3(10, 0.2, 10), dark_mat)
	_add_box("Bed frame", Vector3(-1.4, 0.35, 0.3), Vector3(2.6, 0.45, 3.1), wood_mat)
	_add_box("Mattress", Vector3(-1.4, 0.64, 0.3), Vector3(2.5, 0.25, 3.0), _mat(Color("aaa5b1")))
	_add_box("Blanket", Vector3(-1.4, 0.79, 0.55), Vector3(2.45, 0.12, 2.0), cloth_mat)
	_add_box("Pillow", Vector3(-1.4, 0.83, -0.85), Vector3(1.15, 0.15, 0.55), _mat(Color("d0cbd2")))
	_add_box("Nightstand", Vector3(0.6, 0.45, -0.9), Vector3(0.8, 0.9, 0.8), wood_mat)
	_add_box("Tablet body", Vector3(0.6, 0.96, -0.9), Vector3(0.56, 0.035, 0.38), _mat(Color("10131c")))
	_add_box("Tablet screen", Vector3(0.6, 0.983, -0.9), Vector3(0.49, 0.012, 0.31), _mat(Color("27455b")))
	var screen_glow := OmniLight3D.new()
	screen_glow.position = Vector3(0.6, 1.25, -0.9)
	screen_glow.light_color = Color("5da9df")
	screen_glow.light_energy = 0.5
	screen_glow.omni_range = 2.2
	add_child(screen_glow)
	light = OmniLight3D.new()
	light.position = Vector3(0, 3.4, 0)
	light.light_color = Color("ffe6c6")
	light.light_energy = 1.7
	light.omni_range = 11
	add_child(light)
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("090b12")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("646a85")
	env.ambient_light_energy = 0.35
	world.environment = env
	add_child(world)
	player = Node3D.new()
	player.position = Vector3(0, 1.65, 3.5)
	add_child(player)
	camera = Camera3D.new()
	camera.current = true
	camera.fov = 75
	player.add_child(camera)
	camera.rotation.x = deg_to_rad(-5)

func _build_ui() -> void:
	var ui := CanvasLayer.new()
	add_child(ui)
	var title := Label.new()
	title.text = "ДОМ  •  00:01"
	title.position = Vector2(24, 20)
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color("e1e4ee"))
	ui.add_child(title)
	status_label = Label.new()
	status_label.text = "Ты сидишь на кровати. Пока всё спокойно."
	status_label.position = Vector2(24, 58)
	status_label.add_theme_font_size_override("font_size", 18)
	status_label.add_theme_color_override("font_color", Color("c2c6d4"))
	ui.add_child(status_label)
	var back := Button.new()
	back.text = "В МЕНЮ"
	back.position = Vector2(24, 110)
	back.size = Vector2(150, 48)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/menu.tscn"))
	ui.add_child(back)
	var help := Label.new()
	help.text = "WASD / стрелки — двигаться • На планшете используй кнопки"
	help.anchor_left = 0.03
	help.anchor_right = 0.97
	help.anchor_top = 0.92
	help.anchor_bottom = 0.99
	help.add_theme_font_size_override("font_size", 15)
	help.add_theme_color_override("font_color", Color("b5b8c6"))
	ui.add_child(help)
	ui.add_child(_touch_button("◀", Vector2(25, 540), Vector2(70, 70), func(): move_dir.x = -1))
	ui.add_child(_touch_button("▶", Vector2(180, 540), Vector2(70, 70), func(): move_dir.x = 1))
	ui.add_child(_touch_button("▲", Vector2(102, 490), Vector2(70, 70), func(): move_dir.y = -1))
	ui.add_child(_touch_button("■", Vector2(102, 590), Vector2(70, 60), func(): move_dir = Vector2.ZERO))

func _touch_button(caption: String, pos: Vector2, dimensions: Vector2, action: Callable) -> Button:
	var b := Button.new()
	b.text = caption
	b.position = pos
	b.size = dimensions
	b.add_theme_font_size_override("font_size", 26)
	b.button_down.connect(action)
	b.button_up.connect(func(): move_dir = Vector2.ZERO)
	return b

func _process(delta: float) -> void:
	elapsed += delta
	if Input.is_action_pressed("move_forward"):
		player.position.z -= 2.2 * delta
	if Input.is_action_pressed("move_back"):
		player.position.z += 2.2 * delta
	if Input.is_action_pressed("move_left"):
		player.position.x -= 2.2 * delta
	if Input.is_action_pressed("move_right"):
		player.position.x += 2.2 * delta
	player.position.x += move_dir.x * 2.2 * delta
	player.position.z += move_dir.y * 2.2 * delta
	player.position.x = clampf(player.position.x, -3.9, 3.9)
	player.position.z = clampf(player.position.z, -3.8, 4.0)
	if elapsed > 8.0:
		flicker_timer += delta
		if flicker_timer > 0.12:
			flicker_timer = 0.0
			light.light_energy = randf_range(0.15, 1.8)
			if randf() > 0.93:
				status_label.text = "...Почему свет моргает?"
				status_label.add_theme_color_override("font_color", Color("ff6464"))

func _add_box(label: String, pos: Vector3, dimensions: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = label
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	mesh_instance.mesh = mesh
	mesh_instance.position = pos
	mesh_instance.material_override = material
	add_child(mesh_instance)

func _mat(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material