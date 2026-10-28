class_name CubicCoords

var q: int
var r: int
var s: int

func _init(new_q: int, new_r: int, new_s: int):
	q = new_q
	r = new_r
	s = new_s
	if q + r + s != 0:
		printerr("Invalid cubic coords!")

func to_cartesizan() -> Vector3:
	var x = (q + r / 2.0) * Utils.HEX_RADIUS * sqrt(3)
	var z = r * Utils.HEX_RADIUS * 3 / 2
	return Vector3(x, 0, z)

func to_linear() -> int:
	if q == 0 && r == 0 && s == 0:
		return 0

	var radius = get_radius()
	var minus_radius = -radius
	var hexes = Math.get_number_of_hexes(radius)
	match q:
		radius: # Top-right
			return hexes - s
		minus_radius: # Bottom-left
			return hexes + radius*3 + s
		_:
			match r:
				radius: # Bottom
					return hexes + radius*2 - q
				minus_radius: # Top
					return hexes + radius*5 + q
				_:
					match s:
						radius: # Top-left
							return hexes + radius*4 - r
						minus_radius: # Bottom-right
							return hexes + radius + r
	# Should not get here
	printerr("On no!")
	return 0

func get_radius() -> int:
	var q_a = abs(q)
	var r_a = abs(r)
	var s_a = abs(s)
	return (q_a + r_a + s_a) / 2

func get_neighbour_coords(radius: int, d: int) -> CubicCoords:
	match d:
		0:
			return CubicCoords.new(q+radius*2-1, r-radius, s-(radius-1))
		1:
			return CubicCoords.new(q+radius, r+radius-1, s-(radius*2-1))
		2:
			return CubicCoords.new(q-(radius-1), r+radius*2-1, s-radius)
		3:
			return CubicCoords.new(q-(radius*2-1), r+radius, s+radius-1)
		4:
			return CubicCoords.new(q-radius, r-(radius-1), s+radius*2-1)
		5:
			return CubicCoords.new(q+radius-1, r-(radius*2-1), s+radius)
	# Should not get here
	printerr("Oh no!")
	return CubicCoords.new(0, 0, 0)

func get_all_neighbour_coords() -> Array[CubicCoords]:
	return [
		CubicCoords.new(q+1, r-1, s),
		CubicCoords.new(q+1, r, s-1),
		CubicCoords.new(q, r+1, s-1),
		CubicCoords.new(q-1, r+1, s),
		CubicCoords.new(q-1, r, s+1),
		CubicCoords.new(q, r-1, s+1)
	]

func is_rim() -> bool:
	return (
		abs(q) == Utils.CHUNK_RADIUS - 1 || 
		abs(r) == Utils.CHUNK_RADIUS - 1 ||
		abs(s) == Utils.CHUNK_RADIUS - 1
	)
