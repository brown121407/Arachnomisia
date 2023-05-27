extends Node3D


@export var step_target: Node3D
@export var dist_threshold := 1.25

@onready var target := $Target


func get_leg_bodies() -> Array:
	var skeleton := $Armature/Skeleton3D
	var bodies := []
	for child in skeleton.get_children():
		if child is BoneAttachment3D:
			bodies.push_back(child.get_child(0))
	return bodies

func _physics_process(delta: float) -> void:
	var dist: float = step_target.global_position.distance_to(target.global_position)
#	print('FOOBAR', step_target.position, target.position, dist)
	if dist > dist_threshold:
		target.global_position = step_target.global_position

