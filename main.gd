extends Node3D

var world: World
const ground_plane = Plane(Vector3(0, 1, 0), 0)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_D):
		$MainCamera.position.x += 10 * delta
	if Input.is_key_pressed(KEY_A):
		$MainCamera.position.x -= 10 * delta

func mouse_screen_pos_to_ground_plane(mouse_pos: Vector2) -> Vector3:
	return ground_plane.intersects_ray(
		$MainCamera.project_ray_origin(mouse_pos),
		$MainCamera.project_ray_normal(mouse_pos)
	)

func _input(event):
	if event is InputEventKey and Input.is_action_pressed("quit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_move"):
		var mouse_pos = get_viewport().get_mouse_position()
		var position_3d = mouse_screen_pos_to_ground_plane(mouse_pos)
		var previous_mouse_pos = mouse_pos - event.relative
		var previous_position_3d = mouse_screen_pos_to_ground_plane(previous_mouse_pos)
		$MainCamera.position += (previous_position_3d - position_3d)
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var mouse_pos = get_viewport().get_mouse_position()
		var position3D = ground_plane.intersects_ray(
			$MainCamera.project_ray_origin(mouse_pos),
			$MainCamera.project_ray_normal(mouse_pos)
		)
		
		#var cubic = Math.cartesian_to_cubic(position3D.x, position3D.z)
		#world.paint_hex(0, cubic)

func _ready() -> void:
	Utils.generate_meshes()
	world = World.new(2)
	add_child(world)
