extends Gun


@export var bullet_count := 10

var rng := RandomNumberGenerator.new()

func shoot():
	var shot := super.shoot()
	
	if not shot:
		return
	
	for i in range(0, bullet_count):
		var bullet := bullet_scene.instantiate() as Bullet
		get_tree().root.add_child(bullet)
		bullet.global_position = $Muzzle.global_position
		bullet.velocity = (-global_transform.basis.z + Vector3(rng.randf_range(0, 0.1), rng.randf_range(0, 0.1), rng.randf_range(0, 0.1))) * bullet.muzzle_velocity
	await shot_timer.timeout
