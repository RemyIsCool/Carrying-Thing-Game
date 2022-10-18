extends Node2D


var scene: String

func change_scene(scene_path: String) -> void:
	$AnimationPlayer.play("zoom_in")
	scene = scene_path

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "zoom_in":
		get_tree().change_scene(scene)
		$AnimationPlayer.play("zoom_out")
