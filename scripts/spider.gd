extends CharacterBody3D

@export var movement_speed: float = 2.5
@export var movement_target: Node3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	for leg in $Legs/Left.get_children():
		for body in leg.get_leg_bodies():
			add_collision_exception_with(body)	
	for leg in $Legs/Right.get_children():
		for body in leg.get_leg_bodies():
			add_collision_exception_with(body)	

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	if movement_target: 
		navigation_agent.target_position = movement_target.global_position

func _physics_process(_delta):
	if movement_target:
		var dir := global_position - movement_target.global_position
		look_at(global_position + dir)
		navigation_agent.target_position = movement_target.global_position
		
	if navigation_agent.distance_to_target() < navigation_agent.target_desired_distance:
		velocity = Vector3.ZERO
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()
	
