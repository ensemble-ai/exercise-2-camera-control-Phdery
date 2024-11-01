class_name SpeedUp
extends CameraControllerBase

# Exported Variables
@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2
@export var pushbox_bottom_right: Vector2
@export var speedup_zone_top_left: Vector2
@export var speedup_zone_bottom_right: Vector2

func _ready() -> void:
	super()
	current = false
	is_autoscroll_enabled = false
	position = target.position
	set_process(true)

func _process(delta: float) -> void:
	if not target:
		return
	
	var target_pos = target.position
	var camera_pos = position
	
	var move_x = 0.0
	var move_z = 0.0
	var target_velocity = target.get_velocity()
	
	# Only process movement if target is moving
	if target_velocity.length() > 0:
		# Check if target is inside outer pushbox but not in speedup zone
		if _is_inside_outer_pushbox(target_pos) and not _is_inside_speedup_zone(target_pos):
			if _is_touching_vertical_edge(target_pos):
				# Full speed in x direction, scaled in z direction
				move_x = target_velocity.x
				move_z = target_velocity.z * push_ratio
			elif _is_touching_horizontal_edge(target_pos):
				# Full speed in z direction, scaled in x direction
				move_x = target_velocity.x * push_ratio
				move_z = target_velocity.z
			elif _is_touching_corner(target_pos):
				# Full speed in both directions when in corner
				move_x = target_velocity.x
				move_z = target_velocity.z
			else:
				# Scale both directions when between zones
				move_x = target_velocity.x * push_ratio
				move_z = target_velocity.z * push_ratio

	# Update camera position
	position += Vector3(move_x, 0, move_z) * delta
	
	# Draw debug visualization if enabled
	if draw_camera_logic:
		_draw_push_zones()
	
	super(delta)

func _is_inside_outer_pushbox(pos: Vector3) -> bool:
	return (pushbox_top_left.x <= pos.x and pos.x <= pushbox_bottom_right.x and 
			pushbox_top_left.y <= pos.z and pos.z <= pushbox_bottom_right.y)

func _is_inside_speedup_zone(pos: Vector3) -> bool:
	return (speedup_zone_top_left.x <= pos.x and pos.x <= speedup_zone_bottom_right.x and 
			speedup_zone_top_left.y <= pos.z and pos.z <= speedup_zone_bottom_right.y)

func _is_touching_vertical_edge(pos: Vector3) -> bool:
	return (abs(pos.x - pushbox_top_left.x) < 0.1 or abs(pos.x - pushbox_bottom_right.x) < 0.1) and \
		   (pos.z > pushbox_top_left.y and pos.z < pushbox_bottom_right.y)

func _is_touching_horizontal_edge(pos: Vector3) -> bool:
	return (abs(pos.z - pushbox_top_left.y) < 0.1 or abs(pos.z - pushbox_bottom_right.y) < 0.1) and \
		   (pos.x > pushbox_top_left.x and pos.x < pushbox_bottom_right.x)

func _is_touching_corner(pos: Vector3) -> bool:
	var corner_threshold = 0.1
	return (abs(pos.x - pushbox_top_left.x) < corner_threshold and abs(pos.z - pushbox_top_left.y) < corner_threshold) or \
		   (abs(pos.x - pushbox_bottom_right.x) < corner_threshold and abs(pos.z - pushbox_top_left.y) < corner_threshold) or \
		   (abs(pos.x - pushbox_top_left.x) < corner_threshold and abs(pos.z - pushbox_bottom_right.y) < corner_threshold) or \
		   (abs(pos.x - pushbox_bottom_right.x) < corner_threshold and abs(pos.z - pushbox_bottom_right.y) < corner_threshold)

func _draw_push_zones() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# Draw outer pushbox
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Top line
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	# Right line
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	# Bottom line
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	# Left line
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_end()
	
	# Draw inner speedup zone
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Top line
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	# Right line
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	# Bottom line
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	# Left line
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
