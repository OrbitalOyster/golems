class_name Math

static func get_number_of_hexes(radius: int) -> int:
	if radius == 0:
		return 0
	return 3*radius*radius-3*radius+1

static func linear_to_radius(linear: int) -> int:
	if linear == 0:
		return 0
	return floor((3+sqrt(12*(linear-1)+9))/6)

static func linear_to_cubic(linear: int) -> Vector3i:
	if linear == 0:
		return Vector3i(0, 0, 0)

	var radius = linear_to_radius(linear)
	var d = linear - get_number_of_hexes(radius)
	var side = d / radius
	var q: int
	var r: int
	var s: int
	
	match side:
		0:
			q = radius
			s = -d % radius
			r = -q - s
		1:
			s = -radius
			r = d % radius
			q = -r - s
		2:
			r = radius
			q = -d % radius
			s = -q - r
		3:
			q = -radius
			s = d % radius
			r = -q - s
		4:
			s = radius
			r = -d % radius
			q = -r - s
		5:
			r = -radius
			q = d % radius
			s = -q - r

	return Vector3i(q, r, s)

static func cubic_to_cartesian(q: int, r: int, _s: int) -> Vector3:
	var x = (q + r / 2.0) * Utils.HEX_RADIUS * sqrt(3)
	var z = r * Utils.HEX_RADIUS * 3 / 2
	return Vector3(x, 0, z)

static func cartesian_to_cubic(x: float, y: float) -> Vector3i:
	x = x / Utils.HEX_RADIUS
	y = y / Utils.HEX_RADIUS

	var q = sqrt(3.0)/3.0*x - 1.0/3.0*y
	var r = 2.0 / 3.0 * y
	var s = 0.0 - q - r

	var q_rounded = round(q)
	var r_rounded = round(r)
	var s_rounded = round(s)

	var dq = abs(q_rounded - q)
	var dr = abs(r_rounded - r)
	var ds = abs(s_rounded - s)

	if dq > dr and dq > ds:
		q_rounded = 0.0 - r_rounded - s_rounded
	elif dr > dq and dr > ds:
		r_rounded = 0.0 - q_rounded - s_rounded
	else:
		s_rounded = 0.0 - q_rounded - r_rounded

	return Vector3i(q_rounded, r_rounded, s_rounded)

static func get_radius(q: int, r: int, s: int) -> int:
	if q+r+s != 0:
		printerr("Wrong coords")
	var q_a = abs(q)
	var r_a = abs(r)
	var s_a = abs(s)
	return (q_a + r_a + s_a) / 2

static func cubic_to_linear(q: int, r: int, s: int) -> int:
	if q+r+s != 0:
		printerr("Wrong coords")

	if q == 0 && r == 0 && s == 0:
		return 0

	var radius = get_radius(q, r, s)
	var minus_radius = -radius
	var hexes = get_number_of_hexes(radius)
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

static func get_neighbour_coords(q: int, r: int, s: int, radius: int, d: int) -> Vector3i:
	match d:
		0:
			return Vector3i(q+radius*2-1, r-radius, s-(radius-1))
		1:
			return Vector3i(q+radius, r+radius-1, s-(radius*2-1))
		2:
			return Vector3i(q-(radius-1), r+radius*2-1, s-radius)
		3:
			return Vector3i(q-(radius*2-1), r+radius, s+radius-1)
		4:
			return Vector3i(q-radius, r-(radius-1), s+radius*2-1)
		5:
			return Vector3i(q+radius-1, r-(radius*2-1), s+radius)
	
	# Should not get here
	printerr("Oh no!")
	return Vector3i(0, 0, 0)
