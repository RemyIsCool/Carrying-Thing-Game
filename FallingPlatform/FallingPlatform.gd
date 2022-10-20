extends StaticBody2D


func _physics_process(delta: float) -> void:
	print($PlayerDetector.overlaps_body(GlobalNodes.player))
	if $PlayerDetector.overlaps_body(GlobalNodes.player) and not $FallTimer.time_left > 0:
		$FallTimer.start()


func _on_FallTimer_timeout() -> void:
	$AnimationPlayer.play("crumble")
