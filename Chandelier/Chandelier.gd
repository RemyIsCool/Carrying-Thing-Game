extends KinematicBody2D


export var down_gravity := 30

var y_velocity := 0

var falling := false

func _physics_process(delta: float) -> void:
	if $PlayerDetector.overlaps_body(GlobalNodes.player):
		falling = true
	
	if $PlayerKiller.overlaps_body(GlobalNodes.box):
		falling = true
		GlobalNodes.box.linear_velocity.x = 0
	
	if falling:
		y_velocity += down_gravity
	
	if $PlayerKiller.overlaps_body(GlobalNodes.player):
		GlobalNodes.player.die()
	
	if is_on_floor():
		$AnimationPlayer.play("crash")

	move_and_slide(Vector2(0, y_velocity), Vector2.UP)
