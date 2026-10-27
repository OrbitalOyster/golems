class_name Math

static func get_number_of_hexes(radius: int) -> int:
	# Edge case
	if radius == 0:
		return 0
	else:
		return 3*radius*radius-3*radius+1

static func linear_to_radius(linear: int) -> int:
	# Edge case
	# if linear == 0:
	#	return 0
	return floor((3+sqrt(12*(linear-1)+9))/6)

static func linear_to_cubic(linear: int) -> CubicCoords:
	if linear == 0:
		return CubicCoords.new(0, 0, 0)

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

	return CubicCoords.new(q, r, s)

static func cartesian_to_cubic(x: float, y: float) -> CubicCoords:
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

	return CubicCoords.new(q_rounded, r_rounded, s_rounded)
