extends Node3D


func get_leg_bodies():
	var skeleton := $Armature/Skeleton3D
	var bodies := []
	for child in skeleton.get_children():
		if child is BoneAttachment3D:
			bodies.push_back(child.get_child(0))
	return bodies
