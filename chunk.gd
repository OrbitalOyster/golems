class_name Chunk
extends Node3D

var hexes_node: Node3D
var hexes: Array

var n: int
var center_q: int
var center_r: int
var center_s: int

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
		var cartesian = Math.cubic_to_cartesian(cubic.x, cubic.y, cubic.z)
		var color: Color
		if Math.is_rim_hex(cubic.x, cubic.y, cubic.z):
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

func _init(new_n: int, q: int, r: int, s: int):
	if q+r+s != 0:
		printerr("Wrong coords")
	
	n = new_n
	center_q = q
	center_r = r
	center_s = s
	
	var pos = Math.cubic_to_cartesian(center_q, center_r, center_s)
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

func on_exit():
	print("Chunk exited: #", n)
	free_hexes()

func on_enter():
	print("Chunk entered: #", n)
	generate_hexes()
