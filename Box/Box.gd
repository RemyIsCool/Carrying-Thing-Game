extends RigidBody2D


var was_on_floor := false

func _ready() -> void:
	GlobalNodes.box = self

func _physics_process(delta: float) -> void:
	if not was_on_floor and is_on_floor():
		$LandParticles.restart()
		GlobalNodes.camera.shake(0.15, 1)
	
	was_on_floor = is_on_floor()
	
	$Sprite.visible = not GlobalNodes.player.holding

func is_on_floor() -> bool:
	for body in $GroundDetector.get_overlapping_bodies():
		if body.is_in_group("platform"):
			return true
	return false