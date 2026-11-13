class_name Hex
extends Node3D

signal clicked_on

var index: int

var color: Color = Color.GRAY
var height: float = 0.0
var text = ""
var water_level = 0.0
var temperature = 0.0

var top: MeshInstance3D
var walls: MeshInstance3D
var area3d: Area3D
var label: Label3D

#var notifier_size = Vector3(
	#Utils.HEX_RADIUS * sqrt(3.0),
	#.25,
	#Utils.HEX_RADIUS * 2
#)

func apply_color():
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	#material.albedo_texture = load("res://dirt.jpg")
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	top.set_surface_override_material(0, material)
	walls.set_surface_override_material(0, material)

func set_color(new_color: Color):
	color = new_color
	apply_color()

func set_label(new_text: String):
	text = new_text
	label.text = text

func set_water_level(n: float):
	water_level = n

func set_temperature(n: float):
	temperature = n

func on_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked_on.emit()

func generate_instance():
	top = MeshInstance3D.new()
	top.mesh = Utils.hex_mesh
	walls = MeshInstance3D.new()
	walls.mesh = Utils.hex_walls
	apply_color()
	add_child(top)
	add_child(walls)
	# For 3D mouse picking
	var collisionChape = CollisionShape3D.new()
	collisionChape.shape = top.mesh.create_convex_shape()
	area3d = Area3D.new()
	area3d.input_ray_pickable = true
	area3d.add_child(collisionChape)
	area3d.input_event.connect(on_clicked)
	add_child(area3d)
	# Height
	position.y = height
	# Label
	label = Label3D.new()
	label.text = str(temperature)
	label.position.y = .2
	label.font_size = 32
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func free_instance():
	top.queue_free()
	walls.queue_free()
	area3d.queue_free()
	label.queue_free()

func _init(new_index: int, new_color: Color, new_height: float):
	index = new_index
	color = new_color
	height = new_height
