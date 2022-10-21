extends KinematicBody2D


export var down_gravity := 30

var y_velocity := 0

var falling := false

func _physics_process(delta: float) -> void:
	if $Detector.overlaps_body(GlobalNodes.player):
		falling = true
	
	if $Killer.overlaps_body(GlobalNodes.box):
		falling = true
		GlobalNodes.box.linear_velocity.x = 0
	
	if falling:
		y_velocity += down_gravity
	
	if $Killer.overlaps_body(GlobalNodes.player):
		GlobalNodes.player.die()
	
	if is_on_floor():
		$AnimationPlayer.play("crash")

	move_and_slide(Vector2(0, y_velocity), Vector2.UP)


func _on_Detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("cat_collider"):
		falling = true


func _on_Killer_area_entered(area: Area2D) -> void:
	if area.is_in_group("cat_collider"):
		area.get_parent().die()
