extends Node2D


var on_screen := false

func _process(delta: float) -> void:
	if $VisibilityNotifier2D.is_on_screen() and not on_screen:
		on_screen = true
		$AnimationPlayer.play("crush")
