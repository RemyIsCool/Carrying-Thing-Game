extends StaticBody2D


export var gravity := 10

var yv := 0

onready var start_position := position

var fallen := false

func _physics_process(delta: float) -> void:
	if not fallen:
		if $CollisionDetector.overlaps_body(GlobalNodes.player) and not $FloorDetector.overlaps_body(GlobalNodes.player):
			fallen = true
		return
	
	yv += gravity
	position.y += yv * delta


func _on_FloorDetector_body_entered(body: Node) -> void:
	if body.is_in_group("platform") and body != self:
		fallen = false
		yv = 0
		$CollisionShape2D.call_deferred("set", "disabled", true)
		$Particles.emitting = true
		$Timer.start()
		$Sprite.visible = false

func _on_Timer_timeout() -> void:
	fallen = false
	yv = 0
	position = start_position
	$CollisionShape2D.call_deferred("set", "disabled", false)
	$Particles.restart()
	$Sprite.visible = true
