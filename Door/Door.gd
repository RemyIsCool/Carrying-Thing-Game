extends Area2D


export var next_level_path: String

func _physics_process(delta: float) -> void:
	if overlaps_body(GlobalNodes.player):
		SceneLoader.change_scene(next_level_path)
		$CollisionShape2D.disabled = true
