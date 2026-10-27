class_name Utils

const HEX_RADIUS = .5
const CHUNK_RADIUS = 5

static var hex_mesh: Mesh

static func generate_hex_mesh() -> Mesh:
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	var vertices = PackedVector3Array([
		Vector3(0, 0, 0),
		Vector3(0, 0, -HEX_RADIUS),
		Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2),
		Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2),
		Vector3(0, 0, HEX_RADIUS),
		Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2),
		Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2)
	])

	var indices = PackedInt32Array([
		0, 1, 2,
		0, 2, 3,
		0, 3, 4,
		0, 4, 5,
		0, 5, 6,
		0, 6, 1
	])
	
	#var uvs = PackedVector2Array([
	#	Vector2(.5, .5),
	#	Vector2(.5, 0),
	#	Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 / 4.0),
	#	Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0),
	#	Vector2(.5, 1.0),
	#	Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0),
	#	Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 / 4.0),
	#])
	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	# arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	
	var result = ArrayMesh.new()
	result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return result

static func generate_meshes():
	print("Generating meshes")
	hex_mesh = generate_hex_mesh()
