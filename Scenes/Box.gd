extends RigidBody2D


func _ready() -> void:
	GlobalNodes.box = self

func _physics_process(delta: float) -> void:
	$Sprite.visible = not GlobalNodes.player.holding
