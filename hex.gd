class_name Hex
extends Node3D

signal clicked_on

var color: Color = Color.GRAY
var height: float = 0.0

var instance: MeshInstance3D
var area3d: Area3D

#var notifier_size = Vector3(
	#Utils.HEX_RADIUS * sqrt(3.0),
	#.25,
	#Utils.HEX_RADIUS * 2
#)

func apply_color():
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	instance.set_surface_override_material(0, material)

func set_color(new_color: Color):
	color = new_color
	apply_color()

func on_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked_on.emit()

func generate_instance():
	instance = MeshInstance3D.new()
	instance.mesh = Utils.hex_mesh
	apply_color()
	add_child(instance)
	# For 3D mouse picking
	var collisionChape = CollisionShape3D.new()
	collisionChape.shape = instance.mesh.create_convex_shape()
	area3d = Area3D.new()
	area3d.input_ray_pickable = true
	area3d.add_child(collisionChape)
	area3d.input_event.connect(on_clicked)
	add_child(area3d)
	# Height
	position.y = height

func free_instance():
	instance.queue_free()
	area3d.queue_free()

func _init(new_color: Color, new_height: float):
	color = new_color
	height = new_height
