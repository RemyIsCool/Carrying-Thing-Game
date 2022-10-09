extends PinJoint2D


func _ready() -> void:
	GlobalNodes.joint = self

func _physics_process(delta: float) -> void:
	position = GlobalNodes.player.position - Vector2(0, 16)
