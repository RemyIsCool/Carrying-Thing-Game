extends Area2D


func _physics_process(delta: float) -> void:
	if overlaps_body(GlobalNodes.player):
		GlobalNodes.player.die()
	
	if overlaps_body(GlobalNodes.box):
		GlobalNodes.box.position = GlobalNodes.player.position
