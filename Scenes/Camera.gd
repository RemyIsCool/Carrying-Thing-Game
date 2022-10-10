extends Camera2D


export var lookahead_divisor = 8.5
export var lerp_amount = 0.2
export var y_change = -25

func _ready() -> void:
	position = GlobalNodes.player.position

func _physics_process(delta: float) -> void:
	position.x = lerp(position.x, GlobalNodes.player.position.x + GlobalNodes.player.velocity.x / lookahead_divisor, lerp_amount)
	position.y = lerp(position.y, GlobalNodes.player.position.y + y_change, lerp_amount / 2)
