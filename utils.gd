class_name Utils

const HEX_RADIUS = .5
const CHUNK_RADIUS = 5

static var hex_mesh: Mesh
static var hex_walls: Mesh

static func generate_hex_mesh() -> Mesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# 0 1 2
	st.set_uv(Vector2(.5, .5))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_uv(Vector2(.5, 0))
	st.add_vertex(Vector3(0, 0, -HEX_RADIUS))
	st.set_uv(Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 / 4.0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))

	# 0 2 3
	st.set_uv(Vector2(.5, .5))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_uv(Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 / 4.0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	st.set_uv(Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	
	# 0 3 4
	st.set_uv(Vector2(.5, .5))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_uv(Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	st.set_uv(Vector2(.5, 1.0))
	st.add_vertex(Vector3(0, 0, HEX_RADIUS))

	# 0 4 5
	st.set_uv(Vector2(.5, .5))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_uv(Vector2(.5, 1.0))
	st.add_vertex(Vector3(0, 0, HEX_RADIUS))
	st.set_uv(Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))

	# 0 5 6
	st.set_uv(Vector2(.5, .5))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_uv(Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	st.set_uv(Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 / 4.0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))

	# 0 6 1
	st.set_uv(Vector2(.5, .5))
	st.add_vertex(Vector3(0, 0, 0))
	st.set_uv(Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 / 4.0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	st.set_uv(Vector2(.5, 0))
	st.add_vertex(Vector3(0, 0, -HEX_RADIUS))

	st.generate_normals()
	var mesh = st.commit()
	return mesh
	
	#var arrays = []
	#arrays.resize(Mesh.ARRAY_MAX)
#
	#var vertices = PackedVector3Array([
		#Vector3(0, 0, 0),
		#Vector3(0, 0, -HEX_RADIUS),
		#Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2),
		#Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2),
		#Vector3(0, 0, HEX_RADIUS),
		#Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2),
		#Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2)
	#])
#
	#var indices = PackedInt32Array([
		#0, 1, 2,
		#0, 2, 3,
		#0, 3, 4,
		#0, 4, 5,
		#0, 5, 6,
		#0, 6, 1
	#])
	#
	#var normals = PackedVector3Array([
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP
	#])
	#
	#var uvs = PackedVector2Array([
		#Vector2(.5, .5),
		#Vector2(.5, 0),
		#Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 / 4.0),
		#Vector2(.5 + sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0),
		#Vector2(.5, 1.0),
		#Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 - 1.0/4.0),
		#Vector2(.5 - sqrt(3.0)*.5/2.0, 1.0 / 4.0),
	#])
	#
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#arrays[Mesh.ARRAY_NORMAL] = normals
	#arrays[Mesh.ARRAY_TEX_UV] = uvs
	#arrays[Mesh.ARRAY_INDEX] = indices
	#
	#var result = ArrayMesh.new()
	#result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	#return result

static func generate_hex_walls() -> Mesh:
	const MAX_HEIGHT = 1.0
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)

	# 1 1' 2
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(0, 0, -HEX_RADIUS))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0, -MAX_HEIGHT, -HEX_RADIUS))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))

	# 2 1' 2'
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0, -MAX_HEIGHT, -HEX_RADIUS))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2))

	# 2 2' 3
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))

	# 3 2' 3'
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2))

	# 3 3' 4
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(0, 0, HEX_RADIUS))
	
	# 4 3' 4'
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(0, 0, HEX_RADIUS))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(0, -MAX_HEIGHT, HEX_RADIUS))
	
	# 4 4' 5
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(0, 0, HEX_RADIUS))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0, -MAX_HEIGHT, HEX_RADIUS))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))

	# 5 4' 5'
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0, -MAX_HEIGHT, HEX_RADIUS))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2))
	
	# 5 5' 6
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	
	# 6 5' 6'
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2))
	
	# 6 6' 1
	st.set_uv(Vector2(1, 0))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(0, 0, -HEX_RADIUS))
	
	# 1 6' 1'
	st.set_uv(Vector2(0, 0))
	st.add_vertex(Vector3(0, 0, -HEX_RADIUS))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(0, -MAX_HEIGHT, -HEX_RADIUS))
	
	st.generate_normals()
	
	var mesh = st.commit()
	return mesh

	#var arrays = []
	#arrays.resize(Mesh.ARRAY_MAX)
#
	#const MAX_HEIGHT = 1.0
#
	#var vertices = PackedVector3Array([
		#Vector3(0, 0, -HEX_RADIUS),
		#Vector3(sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2),
		#Vector3(sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2),
		#Vector3(0, 0, HEX_RADIUS),
		#Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, HEX_RADIUS / 2),
		#Vector3(-sqrt(3) * HEX_RADIUS / 2, 0, -HEX_RADIUS / 2),
		#
		#Vector3(0, -MAX_HEIGHT, -HEX_RADIUS),
		#Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2),
		#Vector3(sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2),
		#Vector3(0, -MAX_HEIGHT, HEX_RADIUS),
		#Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, HEX_RADIUS / 2),
		#Vector3(-sqrt(3) * HEX_RADIUS / 2, -MAX_HEIGHT, -HEX_RADIUS / 2)
	#])
#
	#var indices = PackedInt32Array([
		#0, 6, 1,
		#1, 6, 7,
		#1, 7, 2,
		#2, 7, 8,
		#2, 8, 3,
		#3, 8, 9,
		#3, 9, 4,
		#4, 9, 10,
		#4, 10, 5,
		#5, 10, 11,
		#5, 11, 0,
		#0, 11, 6
	#])
	#
	#var normals = PackedVector3Array([
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP,
		#Vector3.UP
	#])
	#
	#var uvs = PackedVector2Array([
		#Vector2(1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(0, 0), 
		#Vector2(1, 1), Vector2(0, 1), Vector2(1, 1), Vector2(0, 1), Vector2(1, 1), Vector2(0, 1)
	#])
	#
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#arrays[Mesh.ARRAY_NORMAL] = normals
	#arrays[Mesh.ARRAY_TEX_UV] = uvs
	#arrays[Mesh.ARRAY_INDEX] = indices
	#
	#var result = ArrayMesh.new()
	#result.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#return result

static func generate_meshes():
	print("Generating meshes")
	hex_mesh = generate_hex_mesh()
	hex_walls = generate_hex_walls()
