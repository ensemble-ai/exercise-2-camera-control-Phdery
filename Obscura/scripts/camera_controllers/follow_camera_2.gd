class_name FollowCamera2
extends CameraControllerBase

@export var lead_speed: float = target_speed + 20
@export var catchup_delay_duration: float = 0.5
@export var catchup_speed: float = 10.0
@export var leash_distance: float = 5.0

var time_since_last_movement: float = 0.0
var target_lead_position: Vector3 = Vector3.ZERO
var input_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	super()
	current = true
	is_autoscroll_enabled = false
	target_lead_position = target.global_position
	set_process(true)

func _process(delta: float) -> void:
	if not target:
		return
	
	var target_position = target.global_position
	var camera_position = global_position

	# 获取输入方向
	input_direction = Vector3.ZERO
	input_direction.x = Input.get_axis("ui_left", "ui_right")
	input_direction.z = Input.get_axis("ui_up", "ui_down")
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()

	# 检测vessel是否在移动
	var target_velocity = target.get_velocity()
	var is_moving = target_velocity.length() > 0

	if is_moving:
		time_since_last_movement = 0.0
		# 根据输入更新相机前进位置
		target_lead_position = target_position + input_direction * leash_distance
		global_position = global_position.lerp(target_lead_position, lead_speed * delta)
	else:
		time_since_last_movement += delta
		if time_since_last_movement >= catchup_delay_duration:
			# 使用lerp方法平滑移动回vessel位置
			global_position = global_position.lerp(target_position, catchup_speed * delta)
	
	if draw_camera_logic and current:
		_draw_center_cross_2()
	
	super(delta)

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
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
