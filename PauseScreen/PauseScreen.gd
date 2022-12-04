extends CanvasLayer


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = not visible
		get_tree().paused = not get_tree().paused