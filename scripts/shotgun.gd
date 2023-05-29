extends Gun


func shoot():
	var shot := super.shoot()
	
	if not shot:
		return
	
	var bullet := bullet_scene.instantiate() as Bullet
	bullet.global_position = $Muzzle.global_position		
	get_tree().root.add_child(bullet)
	bullet.velocity = -global_transform.basis.z * bullet.muzzle_velocity		
	await shot_timer.timeout
