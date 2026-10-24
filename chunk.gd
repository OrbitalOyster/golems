class_name Chunk
extends Node3D

var chunk_shape: Hex

var hexes_node: Node3D
var hexes: Array

var hex_data: Array

var n: int
var q: int
var r: int
var s: int
var radius: int

var notifier: Notifier

func generate_hex_data():
	var size = Math.get_number_of_hexes(radius)
	hex_data.resize(size)
	hexes.resize(size)
	for i in size:
		var cubic = Math.linear_to_cubic(i)
		var c: Color
		if Math.is_rim_hex(cubic.x, cubic.y, cubic.z):
			c = Color.from_hsv(randf(), .9, .2)
			print("Ok")
		else:
			c = Color.from_hsv(randf(), .9, .9)
		hex_data[i] = HexData.new(c)
		
	hex_data[0].set_color(Color.BLACK)

func generate_hex(x: float, z: float, size: float, flat_top: bool) -> Hex:
	var new_hex := Hex.new()
	new_hex.position.x = x
	new_hex.position.z = z
	new_hex.scale.x = size
	new_hex.scale.z = size
	if flat_top:
		new_hex.rotate_y(PI / 2)
	return new_hex

func generate_hexes():
	for i in hexes.size():
		var cubic = Math.linear_to_cubic(i)
		var cartesian = Math.cubic_to_cartesian(cubic.x, cubic.y, cubic.z)
		var new_hex = generate_hex(cartesian.x, cartesian.z, 1, false)
		hexes[i] = new_hex
		hexes_node.add_child(new_hex)
		new_hex.set_color(hex_data[i].color)
	# print("Generated hexes: ", hexes_node.get_child_count(false))

func free_hexes():
	for hex in hexes_node.get_children():
		hex.queue_free()

func _init(new_n: int, new_q: int, new_r: int, new_s: int, new_radius: int):
	n = new_n
	q = new_q
	r = new_r
	s = new_s
	
	if q+r+s != 0:
		printerr("Wrong coords")

	radius = new_radius

	generate_hex_data()
	#print("Generated hex data: ", hex_data.size())

	var pos = Math.cubic_to_cartesian(q, r, s)
	position.x = pos.x
	position.z = pos.z
	
	# var rnd := Color.from_hsv(randf(), .5, .9)
	# for h in hexes.size():
	#	hexes[h].set_color(rnd)

	# chunk_shape = generate_hex(0, 0, Utils.CHUNK_RADIUS * sqrt(3), true)
	# chunk_shape.set_color(Color.WHITE)
	# chunk_shape.position.y = -.01
	# add_child(chunk_shape)

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

func on_exit():
	print("Chunk exited: #", n)
	free_hexes()

func on_enter():
	print("Chunk entered: #", n)
	generate_hexes()
