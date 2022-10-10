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
export var variable_throw := 0.4
export var holding_multiplier := 0.9

var velocity := Vector2.ZERO

var left = false
var was_in_air = false
var holding = false

func _ready() -> void:
	GlobalNodes.player = self

func _physics_process(delta: float) -> void:
	if Input.get_axis("left", "right") == 0 and is_on_floor():
		$SpritesheetAnimation.change_animation(preload("res://Assets/PlayerIdle.png"), 8, 1)
	if Input.get_axis("left", "right") != 0 and is_on_floor():
		if holding:
			$SpritesheetAnimation.change_animation(preload("res://Assets/RunBox.png"), 8, 1)
		else:
			$SpritesheetAnimation.change_animation(preload("res://Assets/PlayerRun.png"), 8, 1)
	if !is_on_floor():
		if holding:
			$SpritesheetAnimation.change_animation(preload("res://Assets/JumpBox.png"), 1, 1)
		else:
			$SpritesheetAnimation.change_animation(preload("res://Assets/PlayerJump.png"), 1, 1)
	
	$WalkParticles.emitting = Input.get_axis("left", "right") != 0 and is_on_floor()
	if Input.is_action_just_pressed("pick_up_throw"):
		if holding:
			GlobalNodes.box.apply_central_impulse((Vector2(-1, -1) if left else Vector2(1, -1)) * 300)
			holding = false
		elif $BoxDetector.overlaps_body(GlobalNodes.box):
			GlobalNodes.box.global_transform.origin = position
			holding = true

	
	GlobalNodes.joint.node_a = "../Player" if holding else ""
	
	if Input.is_action_just_released("pick_up_throw"):
		GlobalNodes.box.linear_velocity *= variable_throw
	
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
	
	velocity.y += down_gravity if velocity.y > 0 else up_gravity
	
	if is_on_floor():
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump"):
		$JumpBufferTimer.start()
	
	if $CoyoteTimer.time_left > 0 and $JumpBufferTimer.time_left > 0:
		velocity.y = -(jump_height * (holding_multiplier if holding else 1))
		$CoyoteTimer.stop()
		$JumpBufferTimer.stop()
		$JumpParticles.restart()
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y += variable_jump
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_pressed("left"):
		left = true
	if Input.is_action_pressed("right"):
		left = false
	
	$SpritesheetAnimation.flip_h = left
	
	if is_on_floor():
		if was_in_air:
			was_in_air = false
			$SpritesheetAnimation.scale = Vector2(1.3, 0.7)
		else:
			$SpritesheetAnimation.scale = lerp($SpritesheetAnimation.scale, Vector2.ONE, 0.1)
			
	else:
		if was_in_air:
			$SpritesheetAnimation.scale = lerp($SpritesheetAnimation.scale, Vector2.ONE, 0.1)
		else:
			was_in_air = true
			$SpritesheetAnimation.scale = Vector2(0.7, 1.3)
	
