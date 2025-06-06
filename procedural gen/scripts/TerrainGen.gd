class_name Terrain_Gen
extends Node

var mesh: MeshInstance3D
var size_depth:int = 100
var size_width:int = 100
var mesh_res = 2
var max_height = 70 

var falloff_image: Image

@export var noise: FastNoiseLite
@export var elevation_curve: Curve

@onready var rng = RandomNumberGenerator.new()
var spawnable_objects: Array[Spawn_object]

func _ready():
	for i in get_children():
		if i is Spawn_object:
			spawnable_objects.append(i)
	
	var falloff_texture = preload("res://Procedural Generation/Textures/TerrainFalloff.png")
	falloff_image = falloff_texture.get_image()
	noise.seed = randi()
	rng.seed = noise.seed
	
	generate()

func generate():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size_width,size_depth)
	plane_mesh.subdivide_depth = size_depth * mesh_res
	plane_mesh.subdivide_width = size_width * mesh_res
	plane_mesh.material = preload("res://Procedural Generation/Materials/TerrainMaterial.tres")
	
	var surface = SurfaceTool.new()
	var data = MeshDataTool.new()
	surface.create_from(plane_mesh, 0)
	
	var array_plane = surface.commit()
	data.create_from_surface(array_plane, 0)
	
	for i in range(data.get_vertex_count()):
		var vertex = data.get_vertex(i)
		
		var y= get_noise(vertex.x,vertex.z)
		vertex.y = y
		data.set_vertex(i,vertex)
	
	array_plane.clear_surfaces()
	
	data.commit_to_surface(array_plane)
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.create_from(array_plane,0)
	surface.generate_normals()
	
	mesh = MeshInstance3D.new()
	mesh.mesh = surface.commit()
	mesh.create_trimesh_collision()
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh.add_to_group("NavSource")
	add_child(mesh)
	
	for obj in spawnable_objects:
		spawn_objects(obj)
	
func get_noise(x,z):
	var value = noise.get_noise_2d(x,z)
	var remmaped_value = (value + 1)/2
	var adjusted_value = elevation_curve.sample(remmaped_value)
	
	var x_percent = (x + (size_depth/2)) / size_depth
	var z_percent = (z + (size_depth/2) )/ size_depth
	
	var x_pixel = int(x_percent * falloff_image.get_width())
	var y_pixel = int(z_percent * falloff_image.get_height())
	
	var falloff = falloff_image.get_pixel(x_pixel,y_pixel).r
	return adjusted_value* max_height * falloff
	
func get_random_position():
	var x = rng.randf_range(-size_width/2,size_width/2)
	var z = rng.randf_range(-size_width/2,size_width/2)
	var y = get_noise(x,z)
	return Vector3(x,y,z)

func spawn_objects(spawnable: Spawn_object):
	for i in range(spawnable.spawn_count):
		var obj = spawnable.scene_to_spawn[rng.randi()% spawnable.scene_to_spawn.size()].instantiate()
		obj.add_to_group("NavSource")
		add_child(obj)
		obj.position = get_random_position()
		obj.scale = Vector3.ONE * rng.randf_range(spawnable.min_scale,spawnable.max_scale)
		obj.rotation_degrees.y = rng.randf_range(0,360)
