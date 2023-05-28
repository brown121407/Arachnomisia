class_name Player
extends CharacterBody3D

@export_group('UI')
@export var ui: UI

@export_group('Stats')
@export_range(0, Constants.MAX_HEALTH) var health := Constants.MAX_HEALTH :
	set(value):
		health = clamp(value, 0, Constants.MAX_HEALTH)
		ui.health = value
@export_range(0, Constants.MAX_STAMINA) var stamina := Constants.MAX_STAMINA :
	set(value):
		stamina = clamp(value, 0, Constants.MAX_STAMINA)
		ui.stamina = value
@export var stamina_depletion_speed := 30.0
@export var stamina_depletion_on_jump := 10.0
@export var stamina_regen_speed := 10.0

@export_group('Controls')
@export var default_speed := 5.0
@export var sprint_speed := 10.0
@export var jump_velocity := 5.25
@export var mouse_sensitivity := 0.05
@export var camera_bob_factor := 0.01

@onready var head := $Head
@onready var camera := $Head/Camera3D as Camera3D
@onready var original_camera_position := camera.position

#@onready var gun := $Head/Gun
#@onready var muzzle := $Head/Gun/Muzzle
#@onready var aimcast := $Head/Camera3D/AimCast


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting('physics/3d/default_gravity') + 2
var sprinting := false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var speed := default_speed
	sprinting = false

	if Input.is_action_pressed('sprint'):
		if stamina > 0:
			speed = sprint_speed
			sprinting = true
		stamina -= stamina_depletion_speed * delta
	else: # not sprinting
		stamina += stamina_regen_speed * delta

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = jump_velocity
		stamina -= stamina_depletion_on_jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward')
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	if velocity != Vector3.ZERO and is_on_floor():
		var camera_bob := Vector3.UP * camera_bob_factor * velocity.length() * sin(Time.get_ticks_msec() / 100)
		tween.tween_property(camera, 'position', original_camera_position + camera_bob, 0.15)
	else:
		tween.tween_property(camera, 'position', original_camera_position, 0.15)

	var collision := move_and_slide()
	# TODO: Handle collision with spider


func _input(event):
	if event.is_action_pressed('shoot'):
		var bullet = get_world_3d().direct_space_state
		var ray_query_params = PhysicsRayQueryParameters3D.new()
		# ray_query_params.from = muzzle.transform.origin
		# ray_query_params.to = aimcast.get_collision_point()
		var collision = bullet.intersect_ray(ray_query_params)

		if collision:
			var target = collision.collider
			if target.is_in_group('Enemy'):
				print('hit enemy')
				# (target as Enemy).take_damage(damage)


	if event.is_action_pressed('ui_cancel'):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
