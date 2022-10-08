extends KinematicBody2D


export var acceleration := 50
export var air_acceleration := 40
export var friction := 200
export var air_friction := 100
export var max_speed := 300
export var jump_height := 500
export var up_gravity := 30
export var down_gravity := 60
export var variable_jump := 100

var velocity := Vector2.ZERO

var left = false
var was_in_air = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if velocity.x < -max_speed + 1 or velocity.x > max_speed - 1:
			velocity.x = max_speed * Input.get_axis("left", "right")
		else:
			velocity.x += (acceleration if is_on_floor() else air_acceleration) * Input.get_axis("left", "right")
	elif velocity.x > friction:
		velocity.x -= friction if is_on_floor() else air_friction
	elif velocity.x < -friction:
		velocity.x += friction if is_on_floor() else air_friction
	else:
		velocity.x = 0
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	velocity.y += down_gravity if velocity.y > 0 else up_gravity
	
	if is_on_floor():
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump"):
		$JumpBufferTimer.start()
	
	if $CoyoteTimer.time_left > 0 and $JumpBufferTimer.time_left > 0:
		velocity.y = -jump_height
		$CoyoteTimer.stop()
		$JumpBufferTimer.stop()
	
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
			$SpritesheetAnimation.scale = lerp($SpritesheetAnimation.scale, Vector2.ONE, 0.15)
			
	else:
		if was_in_air:
			$SpritesheetAnimation.scale = lerp($SpritesheetAnimation.scale, Vector2.ONE, 0.15)
		else:
			was_in_air = true
			$SpritesheetAnimation.scale = Vector2(0.7, 1.3)
	
