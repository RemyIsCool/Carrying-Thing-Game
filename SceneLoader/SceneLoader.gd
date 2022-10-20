extends Node2D


var scene: String

func change_scene(scene_path: String) -> void:
	$CanvasLayer.visible = true
	$AnimationPlayer.play("zoom_in")
	$CanvasLayer/BackBufferCopy/Mask.position = (Vector2(240.526, 135) + (GlobalNodes.player.position - GlobalNodes.camera.position)) if GlobalNodes.player else Vector2(240.526, 135)
	scene = scene_path

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	$CanvasLayer/BackBufferCopy/Mask.position = Vector2(240.526, 135)
	
	if anim_name == "zoom_in":
		get_tree().change_scene(scene)
		$AnimationPlayer.play("zoom_out")
	elif anim_name == "zoom_out":
		$CanvasLayer.visible = false
