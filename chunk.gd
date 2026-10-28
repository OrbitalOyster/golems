class_name Chunk
extends Node3D

var hexes_node: Node3D
var hexes: Array

var center_coords: CubicCoords
var chunk_coords: CubicCoords

var notifier: Notifier

func generate_hex(x: float, z: float, size: float, flat_top: bool, color: Color) -> Hex:
	var new_hex := Hex.new(color)
	new_hex.position.x = x
	new_hex.position.z = z
	new_hex.scale.x = size
	new_hex.scale.z = size
	if flat_top:
		new_hex.rotate_y(PI / 2)
	return new_hex

func generate_hexes():
	var size = Math.get_number_of_hexes(Utils.CHUNK_RADIUS)
	hexes.resize(size)
	for i in size:
		var cubic = Math.linear_to_cubic(i)
		var cartesian = cubic.to_cartesizan()
		var color: Color
		if cubic.is_rim():
			color = Color.from_hsv(randf(), .9, .2)
		else:
			color = Color.from_hsv(randf(), .9, .9)
		var new_hex = generate_hex(cartesian.x, cartesian.z, 1, false, color)
		hexes[i] = new_hex
		hexes_node.add_child(new_hex)
	hexes[0].set_color(Color.BLACK)

func free_hexes():
	for hex in hexes_node.get_children():
		hex.queue_free()

func _init(n: int, new_center_coords: CubicCoords):
	chunk_coords = Math.linear_to_cubic(n)
	center_coords = new_center_coords
	
	var pos = center_coords.to_cartesizan()
	position.x = pos.x
	position.z = pos.z

	# TODO: Not exactly right (a little bigger than actual chunk)
	var aabb_size = Vector3(
		Utils.HEX_RADIUS * sqrt(3.0) * (Utils.CHUNK_RADIUS * 2 - 1),
		.25,
		Utils.HEX_RADIUS * sqrt(3.0) * (Utils.CHUNK_RADIUS * 2 - 1),
	)
	notifier = Notifier.new(aabb_size)
	add_child(notifier)
	notifier.screen_exited.connect(on_exit)
	notifier.screen_entered.connect(on_enter)

	hexes_node = Node3D.new()
	add_child(hexes_node)

func get_neighbour_coords(d: int) -> CubicCoords:
	return chunk_coords.get_neighbour_coords(1, d)

func on_exit():
	# print("Chunk exited: #", n)
	free_hexes()

func on_enter():
	# print("Chunk entered: #", n)
	generate_hexes()
