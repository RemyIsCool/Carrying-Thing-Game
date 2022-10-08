##### Somebody else's code - will replace later

extends KinematicBody2D

export(float) var speed
export(float) var jumpHeight
export(float) var gravity
export(float) var accelaration
#Keyboard Input
export(String) var KrightInput
export(String) var KleftInput
export(String) var KjumpInput
#Controller Input
export(String) var CrightInput
export(String) var CleftInput
export(String) var CjumpInput
#Config charecter settings
export(bool) var Keyboard
export(bool) var Controller

var velocity

## These lines are also mine
var left := false
var holding := true
## The rest is theirs

func _ready():
	velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity
	movement()
	
	velocity = move_and_slide(velocity, Vector.UP)
	
	## This is my code. The government has instructed me to refactor this at another time.
	
	if Input.is_action_just_pressed(KleftInput):
		left = true
	if Input.is_action_just_pressed(KrightInput):
		left = false
	
	if Input.is_action_just_pressed("ui_accept") and holding and $PickupCollider.overlaps_body(get_parent().get_node("./PickUp")):
		get_parent().get_node("./PinJoint2D").node_b = ""
		get_parent().get_node("./PickUp").apply_central_impulse((Vector2(-1, -1) if left else Vector2(1, -1)) * 300)
		get_parent().get_node("./PickUp").global_transform.origin = Vector2(position.x, position.y - 24)
		holding = false
	if Input.is_action_just_released("ui_accept"):
		get_parent().get_node("./PickUp").linear_velocity *= 0.6
	if Input.is_action_just_pressed("ui_down") and $PickupCollider.overlaps_body(get_parent().get_node("./PickUp")):
		holding = true
		get_parent().get_node("./PickUp").global_transform.origin = Vector2(position.x, position.y - 24)
		get_parent().get_node("./PinJoint2D").node_b = "../PickUp"
	
	if holding:
		speed = 75
		accelaration = 15
		jumpHeight = 350
	else:
		speed = 200
		jumpHeight = 400
		accelaration = 25
	
	## This is more of somebody else's code that i found on github

func movement():
	if Keyboard:
		if Input.is_action_pressed(KrightInput):
			velocity.x = speed
		elif Input.is_action_pressed(KleftInput):
			velocity.x = -speed
		else:
			velocity.x = lerp(velocity.x, 0, 0.2)
		if is_on_floor():
			if Input.is_action_just_pressed(KjumpInput):
				velocity.y -= jumpHeight
	if Controller:
		if Input.is_action_pressed(CrightInput):
			velocity.x = speed
		elif Input.is_action_pressed(CleftInput):
			velocity.x = -speed
		else:
			velocity.x = lerp(velocity.x, 0, 0.2)
		if is_on_floor():
			if Input.is_action_just_pressed(CjumpInput):
				velocity.y -= jumpHeight


