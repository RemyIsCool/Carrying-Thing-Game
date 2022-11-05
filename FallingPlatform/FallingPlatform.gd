extends StaticBody2D


export var gravity := 10

onready var start_position := position

var fallen := false

# Never gonna give you up
# Never gonna let you down
# Never gonna run around and desert you
# Never gonna make you cry
# Never gonna say goodbye
# Never gonna tell a lie and hurt you

export var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not fallen:
		if $CollisionDetector.overlaps_body(GlobalNodes.player):
			fallen = true
		return

	velocity.y += gravity

	position += velocity * delta


func _on_CollisionDetector_body_entered(body: Node) -> void:
	if body.is_in_group("platform"):
		fallen = false
		velocity = Vector2.ZERO
		$Timer.start()
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
		$Particles.restart()

func _on_Timer_timeout() -> void:
	fallen = false
	position = start_position
	velocity = Vector2.ZERO
	$Sprite.visible = true
	$CollisionShape2D.disabled = false
	$Particles.restart()

