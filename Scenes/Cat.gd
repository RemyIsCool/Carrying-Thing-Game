extends KinematicBody2D


export var gravity := 40
export var speed := 50

var velocity := Vector2(speed, 0)

func _physics_process(delta: float) -> void:
	if $DeathTimer.time_left > 0:
		$Polygon2D.visible = false
		return
	
	velocity.y += gravity
	
	if is_on_wall():
		velocity.x *= -1
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	
	if not GlobalNodes.box.is_on_floor():
		$BoxBufferTimer.start()
	
	if $CollisionDetection.overlaps_body(GlobalNodes.player):
		GlobalNodes.player.die()
		
	if $CollisionDetection.overlaps_body(GlobalNodes.box) and $BoxBufferTimer.time_left > 0 and not GlobalNodes.player.holding:
		GlobalNodes.box.linear_velocity.y = 0
		GlobalNodes.box.apply_central_impulse(Vector2(0, -200))
		$DeathTimer.start()
		$DeathParticles.restart()
		GlobalNodes.camera.shake(0.1, 2)
	

func _on_DeathTimer_timeout() -> void:
	queue_free()
