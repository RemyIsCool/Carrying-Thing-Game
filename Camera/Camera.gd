extends Camera2D


export var lookahead_divisor = 8.8
export var lerp_amount = 0.2
export var y_change = -25

var amount := 0.0
var shaking := false

func _ready() -> void:
	position = GlobalNodes.player.position
	print(GlobalNodes.player.position)
	print(position)
	print(position == GlobalNodes.player.position)
	GlobalNodes.camera = self

func _physics_process(delta: float) -> void:
	if not GlobalNodes.player.dead:
		position.x = lerp(position.x, GlobalNodes.player.position.x + GlobalNodes.player.velocity.x / lookahead_divisor, lerp_amount)
		position.y = lerp(position.y, GlobalNodes.player.position.y + y_change, lerp_amount / 2)
	
	if shaking:
		position += Vector2((randf() - 0.5) * amount * 2, (randf() - 0.5) * amount * 2)

func shake(length, amt) -> void:
	$ShakeLength.wait_time = length
	$ShakeLength.start()
	shaking = true
	amount = amt

func _on_ShakeLength_timeout() -> void:
	shaking = false
