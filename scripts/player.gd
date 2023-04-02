extends CharacterBody3D


@export var default_speed := 5.0
@export var sprint_speed := 10.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity = 0.05
@export var damage := 100.0

@onready var head := $Head
@onready var camera := $Head/Camera3D
# TODO: Handle head bobbing
#@onready var animation_player := $Head/Camera3D/AnimationPlayer
#@onready var gun := $Head/Gun
#@onready var muzzle := $Head/Gun/Muzzle
#@onready var aimcast := $Head/Camera3D/AimCast

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") + 2
var sprinting := false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var speed := default_speed
	sprinting = false

	if Input.is_action_pressed('sprint'):
		speed = sprint_speed
		sprinting = true

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if velocity != Vector3():
		# animation_player.play("Sprint Head Bob" if sprinting else "Head Bob")
		pass

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
