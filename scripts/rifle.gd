extends Gun


func shoot():
	shooting = true
	
	for i in range(0, 3):
		var shot := super.shoot()
		
		if not shot:
			continue
		
		var bullet := bullet_scene.instantiate() as Bullet
		bullet.global_position = $Muzzle.global_position		
		get_tree().root.add_child(bullet)
		bullet.velocity = -global_transform.basis.z * bullet.muzzle_velocity		
		await shot_timer.timeout

	shooting = false
