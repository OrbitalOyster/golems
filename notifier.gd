class_name Notifier
extends VisibleOnScreenNotifier3D

var notifier_shape: MeshInstance3D

func _init(aabb_size: Vector3):
	var aabb_position = -aabb_size / 2
	aabb_position.y = 0
	aabb = AABB(aabb_position, aabb_size)
	notifier_shape = MeshInstance3D.new()
	notifier_shape.position = aabb.get_center()
	var notifier_shape_mesh = BoxMesh.new()
	notifier_shape_mesh.size = aabb_size
	notifier_shape.mesh = notifier_shape_mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.from_hsv(randf(), .9, .9, .2)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	notifier_shape.set_surface_override_material(0, material)
	# add_child(notifier_shape)
