extends KinematicBody2D


export var gravity := 40
export var speed := 50
export var left := false
export (int, "Dark Grey", "Orange", "Dark Brown", "Light Brown", "Red", "Green", "White", "Black", "Fat") var cat := 1

onready var velocity := Vector2(speed, 0)

var dead := false

var texture: Texture
var dead_texture: Texture

func _ready() -> void:
	texture = load("res://Cat/Art/Cat" + str(cat + 1) + ".png")
	dead_texture = load("res://Cat/Art/CatDeath" + str(cat + 1) + ".png")

	$SpritesheetAnimation.texture = texture
	
	if left:
		velocity.x *= -1

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if not $VisibilityNotifier2D.is_on_screen():
		return
	
	velocity.y += gravity
	
	if is_on_wall():
		velocity.x *= -1
	
	$SpritesheetAnimation.flip_h = velocity.x <= 0
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	
	if not GlobalNodes.box.is_on_floor():
		$BoxBufferTimer.start()
	
	if $CollisionDetection.overlaps_body(GlobalNodes.player) and not $DeathTimer.time_left > 0:
		GlobalNodes.player.die()
		
	if $CollisionDetection.overlaps_body(GlobalNodes.box) and not GlobalNodes.player.holding:
		if $BoxBufferTimer.time_left > 0:
			die()
		else:
			$TeleportParticles.restart()
			GlobalNodes.box.position = GlobalNodes.player.position
	
func die() -> void:
	dead = true
	GlobalNodes.box.linear_velocity.y = 0
	GlobalNodes.box.apply_central_impulse(Vector2(0, -200))
	$SpritesheetAnimation.change_animation(dead_texture, 1, 1)
	$SpritesheetAnimation.position.y += 4
	$AnimationPlayer.play("die")
	GlobalNodes.camera.shake(0.1, 2)
