class_name Hex
extends Node3D

var instance: MeshInstance3D

var notifier_size = Vector3(
	Utils.HEX_RADIUS * sqrt(3.0),
	.25,
	Utils.HEX_RADIUS * 2
)
var notifier: Notifier

func set_color(new_color: Color):
	var material = StandardMaterial3D.new()
	material.albedo_color = new_color
	instance.set_surface_override_material(0, material)

func generate_instance():
	instance = MeshInstance3D.new()
	instance.mesh = Utils.hex_mesh
	add_child(instance)

func free_instance():
	instance.queue_free()
	# notifier.queue_free()
	# instance.call_deferred("free")
	# notifier.call_deferred("free")


func _init():
	# notifier = Notifier.new(notifier_size)
	# notifier.screen_exited.connect(on_exit)
	# notifier.screen_entered.connect(on_enter)
	# add_child(notifier)
	generate_instance()

func on_enter():
	# print("Generated hex")
	generate_instance()
	
func on_exit():
	# print("Freed hex")
	free_instance()
