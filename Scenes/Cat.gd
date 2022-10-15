extends KinematicBody2D


export var gravity := 40
export var speed := 50

var velocity := Vector2(speed, 0)

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	
	if is_on_wall():
		velocity.x *= -1
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	
	if $CollisionDetection.overlaps_body(GlobalNodes.player):
		get_tree().reload_current_scene()
	
	if $CollisionDetection.overlaps_body(GlobalNodes.box) and not GlobalNodes.box.is_on_floor() and not GlobalNodes.player.holding:
		GlobalNodes.box.apply_central_impulse(Vector2(0, -500))
		queue_free()