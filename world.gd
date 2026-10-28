extends Node
class_name World

var chunks: Array

func get_hex_neighbours(chunk_n: int, hex_coords: CubicCoords) -> Array[Hex]:
	var chunk = chunks[chunk_n]
	var result: Array[Hex]
	result.resize(6)
	var neighbour_coords = hex_coords.get_all_neighbour_coords()
	for i in 6:
		result[i] = chunk.hexes[neighbour_coords[i].to_linear()]
	return result

func paint_hex(chunk_n: int, coords: CubicCoords):
	chunks[chunk_n].hexes[coords.to_linear()].set_color(Color.DARK_GRAY)
	print(coords.q, "/", coords.r, "/", coords.s, " ", coords.to_linear())
	var neighbour_coords = coords.get_all_neighbour_coords()
	if coords.is_rim():
		# Top-right
		if coords.q == Utils.CHUNK_RADIUS - 1:
			var neighbour_n = chunks[chunk_n].get_neighbour_coords(0).to_linear()
			var neighbour_hex_coords = CubicCoords.new(-coords.q, -coords.s, -coords.r)
			chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
		else: if coords.r == -(Utils.CHUNK_RADIUS - 1):
			var neighbour_n = chunks[chunk_n].get_neighbour_coords(5).to_linear()
			var neighbour_hex_coords = CubicCoords.new(-coords.s + 1, -coords.r, -coords.q - 1)
			chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
		else:
			chunks[chunk_n].hexes[neighbour_coords[0].to_linear()].set_color(Color.GRAY)
			#if cubic.s == -(Utils.CHUNK_RADIUS - 1):
			#var neighbour_n = chunks[chunk_n].get_neighbour_coords(1).to_linear()
			#var neighbour_hex_coords = CubicCoords.new(-cubic.r, -cubic.q, -cubic.s)
			#chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
		#if cubic.r == Utils.CHUNK_RADIUS - 1:
			#var neighbour_n = chunks[chunk_n].get_neighbour_coords(2).to_linear()
			#var neighbour_hex_coords = CubicCoords.new(-cubic.s, -cubic.r, -cubic.q)
			#chunks[neighbour_n].hexes[neighbour_hex_coords.to_linear()].set_color(Color.GRAY)
	else:
		for hex in get_hex_neighbours(chunk_n, coords):
			hex.set_color(Color.GRAY)

func on_hex_clicked(chunk_n: int, hex_n: int):
	print("Hex clicked ", chunk_n, " ", hex_n)
	var cubic_coords = Math.linear_to_cubic(hex_n)
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
