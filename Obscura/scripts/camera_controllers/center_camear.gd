class_name CenterCamera
extends CameraControllerBase

# Stage 1
func _ready() -> void:
	super()
	
	# Set the center camera as the default camera
	current = true
	is_autoscroll_enabled = false
	position = target.position
	set_process(true)
	

func _process(delta: float) -> void:
	if !current:
		return
		
	if draw_camera:
		_draw_center_cross_center()
		
	if target:
		# Center the camera on the vessel
		global_position = Vector3(target.global_position.x, global_position.y, target.global_position.z)
	
	super(delta)

# Draw the white cross line in this stage
func _draw_center_cross_center() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -10 / 2
	var right:float = 10 / 2
	var top:float = 0.01
	var bottom:float = -0.01
	
	# Horizontal line
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()
	
	
	var left_v:float = 0
	var right_v:float = 0
	var top_v:float = 5
	var bottom_v:float = -5
	
	# Vertical line
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, top_v))
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, bottom_v))
	
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, bottom_v))
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, bottom_v))
	
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, bottom_v))
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, top_v))
	
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, top_v))
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, top_v))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
