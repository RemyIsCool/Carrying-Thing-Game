extends KinematicBody2D


export var acceleration := 50
export var air_acceleration := 40
export var friction := 200
export var air_friction := 100
export var max_speed := 200
export var jump_height := 500
export var up_gravity := 30
export var down_gravity := 60
export var variable_jump := 100
export var variable_throw := 0.3
export var holding_multiplier := 0.95

var velocity := Vector2.ZERO

var left = false
var was_in_air = false
var holding = true
var has_slowed_down = false
var jumped = false
var dead = false

func _ready() -> void:
	GlobalNodes.player = self

func _physics_process(delta: float) -> void:
	# Skip the rest if the player is dead
	if dead:
		if holding:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/IdleBox.png"), 8, 1)
		else:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/PlayerIdle.png"), 8, 1)
		
		velocity.y += down_gravity if velocity.y > 0 else up_gravity
		move_and_slide(Vector2(0, velocity.y))
		return
	
	# Animations
	if Input.get_axis("left", "right") == 0 and is_on_floor():
		if holding:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/IdleBox.png"), 8, 1)
		else:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/PlayerIdle.png"), 8, 1)
	if Input.get_axis("left", "right") != 0 and is_on_floor():
		if holding:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/RunBox.png"), 8, 1)
		else:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/PlayerRun.png"), 8, 1)
	if not is_on_floor():
		if holding:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/JumpBox.png"), 1, 1)
		else:
			$SpritesheetAnimation.change_animation(preload("res://Player/Art/PlayerJump.png"), 1, 1)
	
	# Picking up and throwing
	if Input.is_action_just_pressed("pick_up_throw"):
		if holding:
			GlobalNodes.box.linear_velocity = Vector2.ZERO
			GlobalNodes.box.apply_central_impulse((Vector2(-1, -1) if left else Vector2(1, -1)) * 300)
			holding = false
			has_slowed_down = false
		elif $BoxDetector.overlaps_body(GlobalNodes.box):
			GlobalNodes.box.global_transform.origin = position
			holding = true
	
	GlobalNodes.box.get_node("./Sprite").texture = preload("res://Box/Art/BoxTouching.png") if $BoxDetector.overlaps_body(GlobalNodes.box) and GlobalNodes.box.is_on_floor() else preload("res://Box/Art/Box.png")
	
	GlobalNodes.joint.node_a = "../Player" if holding else ""
	
	if Input.is_action_just_released("pick_up_throw") and not has_slowed_down:
		GlobalNodes.box.linear_velocity.x *= variable_throw
		has_slowed_down = true
	
	# Horizontal movement
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if velocity.x < -max_speed + 1 or velocity.x > max_speed - 1:
			velocity.x = max_speed * Input.get_axis("left", "right")
		else:
			velocity.x += (acceleration if is_on_floor() else air_acceleration) * Input.get_axis("left", "right") * (holding_multiplier if holding else 1)
	elif velocity.x > friction:
		velocity.x -= friction if is_on_floor() else air_friction
	elif velocity.x < -friction:
		velocity.x += friction if is_on_floor() else air_friction
	else:
		velocity.x = 0
	
	velocity.x = clamp(velocity.x, -max_speed * (holding_multiplier if holding else 1), max_speed * (holding_multiplier if holding else 1))
	
	if Input.is_action_pressed("left"):
		left = true
	if Input.is_action_pressed("right"):
		left = false
	
	$SpritesheetAnimation.flip_h = left	
	
	
	# Vertical movement
	velocity.y += down_gravity if velocity.y > 0 else up_gravity
	
	if is_on_floor():
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump"):
		$JumpBufferTimer.start()
	
	if $CoyoteTimer.time_left > 0 and $JumpBufferTimer.time_left > 0:
		velocity.y = -(jump_height * (holding_multiplier if holding else 1))
		$CoyoteTimer.stop()
		$JumpBufferTimer.stop()
		jumped = true
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y += variable_jump
	
	# Actually moving the player
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Visual effects
	$WalkParticles.emitting = Input.get_axis("left", "right") != 0 and is_on_floor() and not is_on_wall()
	
	if jumped:
		$JumpParticles.restart()
		jumped = false
	
	if is_on_floor():
		if was_in_air:
			was_in_air = false
			$SpritesheetAnimation.scale = Vector2(1.3, 0.7)
			$LandParticles.restart()
			GlobalNodes.camera.shake(0.1, 1)
		else:
			$SpritesheetAnimation.scale = lerp($SpritesheetAnimation.scale, Vector2.ONE, 0.1)
			
	else:
		if was_in_air:
			$SpritesheetAnimation.scale = lerp($SpritesheetAnimation.scale, Vector2.ONE, 0.1)
		else:
			was_in_air = true
			$SpritesheetAnimation.scale = Vector2(0.7, 1.3)

func die() -> void:
	if not dead:
		dead = true
		SceneLoader.change_scene(get_tree().current_scene.filename)
		$SpritesheetAnimation.change_animation(preload("res://Player/Art/PlayerIdle.png"), 8, 1)
		$SpritesheetAnimation.scale = Vector2.ONE
		GlobalNodes.camera.shake(0.2, 4)
