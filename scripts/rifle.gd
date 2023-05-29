extends Gun


func shoot():
	for i in range(0, 3):
		super.shoot()
		await shot_timer.timeout

#	var bullet = get_world_3d().direct_space_state
#	var ray_query_params = PhysicsRayQueryParameters3D.new()
#	# ray_query_params.from = muzzle.transform.origin
#	# ray_query_params.to = aimcast.get_collision_point()
#	var collision = bullet.intersect_ray(ray_query_params)
#
#	if collision:
#		var target = collision.collider
#		if target.is_in_group('Enemy'):
#			print('hit enemy')
#			# (target as Enemy).take_damage(damage)
