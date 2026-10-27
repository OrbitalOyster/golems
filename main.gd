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
			var chunk_coords = Math.linear_to_cubic(j)
			for d in 6:
				# Chunk coordinates ( / radius)
				var neighbour_number = chunk_coords.get_neighbour_coords(1, d).to_linear()
				if chunks[neighbour_number] == null:
					var pos = chunks[j].center_coords.get_neighbour_coords(Utils.CHUNK_RADIUS, d)
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
		chunks[0].hexes[cubic.to_linear()].set_color(Color.DARK_GRAY)
		print(cubic.q, "/", cubic.r, "/", cubic.s, " ", cubic.to_linear())
		if cubic.is_rim():
			if cubic.q == Utils.CHUNK_RADIUS - 1:
				var neighbour_n = chunks[0].get_neighbour_coords(0).to_linear()
				var neighbour_hex_coords = CubicCoords.new(-cubic.q, -cubic.s, -cubic.r)
				chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
			if cubic.s == -(Utils.CHUNK_RADIUS - 1):
				var neighbour_n = chunks[0].get_neighbour_coords(1).to_linear()
				var neighbour_hex_coords = CubicCoords.new(-cubic.r, -cubic.q, -cubic.s)
				chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
			if cubic.r == Utils.CHUNK_RADIUS - 1:
				var neighbour_n = chunks[0].get_neighbour_coords(2).to_linear()
				var neighbour_hex_coords = CubicCoords.new(-cubic.s, -cubic.r, -cubic.q)
				chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
		else:
			for d in 6:
				var neighbour = cubic.get_neighbour_coords(1, d)
				var linear = neighbour.to_linear()
				chunks[0].hexes[linear].set_color(Color.GRAY)

func _ready() -> void:
	Utils.generate_meshes()
	generate_world(2)
