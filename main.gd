extends Node3D

const ground_plane = Plane(Vector3(0, 1, 0), 0)
var chunks: Array

func generate_world(radius: int):
	var world_size = Math.get_number_of_hexes(radius)
	print("Chunks to generate: ", world_size)
	chunks.resize(world_size)
	print("World size: ", world_size * Math.get_number_of_hexes(Utils.CHUNK_RADIUS))
	
	var first_chunk = Chunk.new(0, CubicCoords.new(0, 0, 0))
	chunks[0] = first_chunk
	add_child(first_chunk)
	
	for i in range(1, radius):
		var chunks_done = Math.get_number_of_hexes(i - 1)
		var chunks_to_generate = Math.get_number_of_hexes(i)
		for j in range(chunks_done, chunks_to_generate):
			var ltc = Math.linear_to_cubic(j)
			for d in 6:
				# Chunk coordinates ( / radius)
				var nc = ltc.get_neighbour_coords(1, d)
				var neighbour_number = nc.to_linear()
				if chunks[neighbour_number] == null:
					var pos = chunks[j].center.get_neighbour_coords(Utils.CHUNK_RADIUS, d)
					var new_chunk = Chunk.new(neighbour_number, pos)
					chunks[neighbour_number] = new_chunk
					add_child(new_chunk)

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
		var cubic = Math.cartesian_to_cubic(position3D.x, position3D.z)
		var linear = cubic.to_linear()
		print(cubic.q, "/", cubic.r, "/", cubic.s, " ", linear)
		chunks[0].hexes[linear].set_color(Color.GRAY)

func _ready() -> void:
	Utils.generate_meshes()
	generate_world(2)
