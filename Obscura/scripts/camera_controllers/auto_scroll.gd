class_name AutoScroll
extends CameraControllerBase


@export var top_left: Vector2
@export var bottom_right: Vector2
@export var autoscroll_speed: Vector3 = Vector3(20, 0, 0)

var box_width_a:float = 27.0
var box_height_a:float = 15.0


func _ready() -> void:
	super()
	is_autoscroll_enabled = true
	current = false
	position = target.position
	#position = Vector3(0, 10, 0)
	set_process(true)

func _process(delta: float) -> void:
	# Autoscroll logic
	if current:
		global_transform.origin.x += autoscroll_speed.x * delta
		global_transform.origin.z += autoscroll_speed.z * delta
	_draw_frame_box()
		
	var frame_left = top_left.x + global_transform.origin.x - 13
	if target.position.x <= frame_left:
	# Apply push to the right to avoid getting stuck
		target.global_position.x += autoscroll_speed.x * delta
			
	#boundary checks
	var tpos = target.global_position
	var cpos = global_position
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width_a / 2.0)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width_a / 2.0)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height_a / 2.0)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height_a / 2.0)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	
	super(delta)

# Draw the frame box for Stage 2
func _draw_frame_box() -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	var top_left_3d = Vector3(top_left.x, 0, top_left.y)
	var top_right_3d = Vector3(bottom_right.x, 0, top_left.y)
	var bottom_left_3d = Vector3(top_left.x, 0, bottom_right.y)
	var bottom_right_3d = Vector3(bottom_right.x, 0, bottom_right.y)

	immediate_mesh.clear_surfaces()
	# Draw frame border box
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(top_left_3d)
	immediate_mesh.surface_add_vertex(top_right_3d)

	immediate_mesh.surface_add_vertex(top_right_3d)
	immediate_mesh.surface_add_vertex(bottom_right_3d)

	immediate_mesh.surface_add_vertex(bottom_right_3d)
	immediate_mesh.surface_add_vertex(bottom_left_3d)

	immediate_mesh.surface_add_vertex(bottom_left_3d)
	immediate_mesh.surface_add_vertex(top_left_3d)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
