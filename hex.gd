class_name Hex
extends Node3D

var color: Color
var instance: MeshInstance3D

var notifier_size = Vector3(
	Utils.HEX_RADIUS * sqrt(3.0),
	.25,
	Utils.HEX_RADIUS * 2
)

func apply_color():
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	instance.set_surface_override_material(0, material)

func set_color(new_color: Color):
	color = new_color
	apply_color()

func generate_instance():
	instance = MeshInstance3D.new()
	instance.mesh = Utils.hex_mesh
	apply_color()
	add_child(instance)

func free_instance():
	instance.queue_free()

func _init(new_color: Color):
	color = new_color
	generate_instance()

func on_enter():
	generate_instance()
	
func on_exit():
	free_instance()
