class_name SpeedUp
extends CameraControllerBase

# Stage 5
@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-13.5, 8)
@export var pushbox_bottom_right: Vector2 = Vector2(13.5, -8)
@export var speedup_zone_top_left: Vector2 = Vector2(-10, 8)
@export var speedup_zone_bottom_right: Vector2 = Vector2(10, -8)

func _ready() -> void:
	super()
	current = false
	is_autoscroll_enabled = false
	position = target.position

func _process(delta: float) -> void:
	if not current:
		position = target.position
		return

	if draw_camera and current:
		_draw_zones()

	var target_velocity = target.velocity
	var camera_movement = Vector3.ZERO

	# If the target is not moving, limit the target to the range of the push box
	if target_velocity == Vector3.ZERO:
		target.position.x = clamp(target.position.x, position.x + pushbox_top_left.x, position.x + pushbox_bottom_right.x)
		target.position.z = clamp(target.position.z, position.z + pushbox_bottom_right.y, position.z + pushbox_top_left.y)
		
	# If the target is moving, check to see if it is within the acceleration zone
	else:
		var in_speedup_zone = target.position.x > position.x + speedup_zone_top_left.x and target.position.x < position.x + speedup_zone_bottom_right.x \
							  and target.position.z > position.z + speedup_zone_bottom_right.y and target.position.z < position.z + speedup_zone_top_left.y

		# If not in the acceleration area, check whether the target is on the edge of the push box and adjust the camera movement
		if not in_speedup_zone:
			if target.position.x <= position.x + pushbox_top_left.x or target.position.x >= position.x + pushbox_bottom_right.x:
				camera_movement.x = target_velocity.x
			else:
				camera_movement.z = target_velocity.x * push_ratio
				
			if target.position.z <= position.z + pushbox_bottom_right.y or target.position.z >= position.z + pushbox_top_left.y:
				camera_movement.x = target_velocity.z
			else:
				camera_movement.z = target_velocity.z * push_ratio

	# Update camera position
	position += camera_movement * delta
	super(delta)

# The frame box for this stage
func _draw_zones() -> void:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE

	immediate_mesh.clear_surfaces()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw pushbox
	var left = pushbox_top_left.x
	var right = pushbox_bottom_right.x
	var top = pushbox_top_left.y
	var bottom = pushbox_bottom_right.y

	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))

	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))

	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))

	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	# Draw speedup zone
	left = speedup_zone_top_left.x
	right = speedup_zone_bottom_right.x
	top = speedup_zone_top_left.y
	bottom = speedup_zone_bottom_right.y

	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))

	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))

	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))

	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	immediate_mesh.surface_end()

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	await get_tree().process_frame
	mesh_instance.queue_free()
