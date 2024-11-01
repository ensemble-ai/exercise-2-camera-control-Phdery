class_name FollowCamera2
extends CameraControllerBase

# Stage 4
@export var lead_speed: float = 25.0
@export var catchup_speed: float = 40.0
@export var catchup_delay_duration: float = 0.5
@export var leash_distance: float = 7.5
var stop_timer: float = 0.0

func _ready() -> void:
	super()
	current = false
	position = target.position

func _process(delta: float) -> void:
	if not current:
		return

	if draw_camera and current:
		_draw_center_cross_2()

	var target_pos = target.global_position
	var camera_pos = global_position

	if target.velocity.length() > 0:
		# Reset the stop timer when the target is moving
		stop_timer = 0.0

		# The desired camera position ahead of the target
		var direction = target.velocity.normalized()
		var desired_position = target_pos + direction * leash_distance

		# Smoothly move the camera towards the desired position
		global_position = global_position.lerp(desired_position, lead_speed * delta)
	else:
		# Increment the stop timer when the target is stationary
		stop_timer += delta

		# After the delay, move the camera towards the target
		if stop_timer >= catchup_delay_duration and camera_pos != target_pos:
			global_position = global_position.lerp(target_pos, catchup_speed * delta)

	super(delta)

# Draw the white cross line in this stage
func _draw_center_cross_2() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	immediate_mesh.clear_surfaces()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -10 / 2 + 0.28
	var right:float = 10 / 2 + 0.30
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
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
