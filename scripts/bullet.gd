class_name Bullet
extends Area3D


@export var damage := 30
@export var muzzle_velocity := 10
@export var g := Vector3.DOWN * 10

var velocity := Vector3.ZERO


func _physics_process(delta):
	velocity += delta * g
	look_at(position + velocity.normalized(), Vector3.UP)
	position += velocity * delta


func _on_body_entered(body: Node3D):
	if body.is_in_group('Enemy'):
		var spider: Spider
		if body is Spider:
			spider = body
		else: # spider leg
			spider = body.owner.owner
		spider.health -= damage
	queue_free()
			
