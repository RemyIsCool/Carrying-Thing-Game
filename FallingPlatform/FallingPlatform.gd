extends StaticBody2D



func _physics_process(delta: float) -> void:
	if $PlayerDetector.overlaps_body(GlobalNodes.player) and $FallTimer.time_left <= 0:
		$FallTimer.start()

func _on_AppearTimer_timeout() -> void:
	$AnimationPlayer.play("RESET")

# Never gonna give you up
# Never gonna let you down
# Never gonna run around and desert you
# Never gonna make you cry
# Never gonna say goodbye
# Never gonna tell a lie and hurt you


func _on_FallTimer_timeout() -> void:
	if $PlayerDetector.overlaps_body(GlobalNodes.player):
		$AnimationPlayer.play("crumble")