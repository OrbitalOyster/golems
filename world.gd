class_name World
extends Node3D

var chunks: Array

func get_chunk_neighbour(chunk: Chunk, d: int) -> Chunk:
	var coords = chunk.get_neighbour_coords(d)
	var linear = coords.to_linear()
	if linear >= chunks.size():
		return null
	else:
		return chunks[linear]

func get_hex_neighbours(chunk_n: int, hex_coords: CubicCoords) -> Array[Hex]:
	var chunk = chunks[chunk_n]
	var q = hex_coords.q
	var r = hex_coords.r
	var s = hex_coords.s
	var result: Array[Hex]
	result.resize(6)
	if hex_coords.is_rim():
		# Top-right && right
		if q == Utils.CHUNK_RADIUS - 1:
			var neighbour = get_chunk_neighbour(chunk, 0)
			if neighbour != null:
				result[0] = neighbour.get_hex(CubicCoords.new(-q, -s, -r))
				result[1] = neighbour.get_hex(CubicCoords.new(-q, -s+1, -r-1))
		# Right && bottom-right
		if s == -(Utils.CHUNK_RADIUS - 1):
			var neighbour = get_chunk_neighbour(chunk, 1)
			if neighbour != null:
				result[1] = neighbour.get_hex(CubicCoords.new(-r, -q, -s))
				result[2] = neighbour.get_hex(CubicCoords.new(-r-1, -q+1, -s))
		# Bottom-right && bottom-left
		if r == Utils.CHUNK_RADIUS - 1:
			var neighbour = get_chunk_neighbour(chunk, 2)
			if neighbour != null:
				result[2] = neighbour.get_hex(CubicCoords.new(-s, -r, -q))
				result[3] = neighbour.get_hex(CubicCoords.new(-s-1, -r, -q+1))
		# Bottom-left && right
		if q == -(Utils.CHUNK_RADIUS - 1):
			var neighbour = get_chunk_neighbour(chunk, 3)
			if neighbour != null:
				result[3] = neighbour.get_hex(CubicCoords.new(-q, -s, -r))
				result[4] = neighbour.get_hex(CubicCoords.new(-q, -s-1, -r+1))
		# Right && top-right
		if s == Utils.CHUNK_RADIUS - 1:
			var neighbour = get_chunk_neighbour(chunk, 4)
			if neighbour != null:
				result[4] = neighbour.get_hex(CubicCoords.new(-r, -q, -s))
				result[5] = neighbour.get_hex(CubicCoords.new(-r+1, -q-1, -s))
		# Top-right && top
		if r == -(Utils.CHUNK_RADIUS - 1):
			var neighbour = get_chunk_neighbour(chunk, 5)
			if neighbour != null:
				result[5] = neighbour.get_hex(CubicCoords.new(-s, -r, -q))
				result[0] = neighbour.get_hex(CubicCoords.new(-s+1, -r, -q-1))
		# Top && top-right (single hex)
		if r == -(Utils.CHUNK_RADIUS - 1) && q == Utils.CHUNK_RADIUS - 1:
			var neighbour = get_chunk_neighbour(chunk, 0)
			if neighbour != null:
				result[0] = neighbour.get_hex(CubicCoords.new(-q, -s, -r))

	var neighbour_coords = hex_coords.get_all_neighbour_coords()
	for i in 6:
		if result[i] == null:
			result[i] = chunk.hexes[neighbour_coords[i].to_linear()]
	return result

func paint_hex(chunk_n: int, coords: CubicCoords):
	var neighbours = get_hex_neighbours(chunk_n, coords)
	for hex in neighbours:
		if hex != null:
			hex.set_color(Color.DIM_GRAY)

func on_hex_clicked(chunk_n: int, hex_n: int):
	var cubic_coords = Math.linear_to_cubic(hex_n)
	print("Hex clicked ", chunk_n, "[", hex_n, "] ", cubic_coords.q, "/",cubic_coords.r, "/", cubic_coords.s)
	paint_hex(chunk_n, cubic_coords)

func _init(radius: int):
	var size = Math.get_number_of_hexes(radius)
	print("Chunks to generate: ", size)
	chunks.resize(size)
	print("World size: ", size * Math.get_number_of_hexes(Utils.CHUNK_RADIUS))
	var first_chunk = Chunk.new(0, CubicCoords.new(0, 0, 0))
	first_chunk.hex_clicked_on.connect(func(hex_n): on_hex_clicked(0, hex_n))
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
					new_chunk.hex_clicked_on.connect(func(hex_n): on_hex_clicked(neighbour_number, hex_n))
					chunks[neighbour_number] = new_chunk
					add_child(new_chunk)
