extends RigidBody2D


var is_held := false

func _physics_process(delta):
	for body in get_colliding_bodies():
		if body.is_in_group("platform") and not is_held:
			mode = RigidBody2D.MODE_STATIC
	if is_held:
		mode = RigidBody2D.MODE_CHARACTER
