extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 5.0
const JUMP_VELOCITY = -450.0

var inJump
var inHang
var inFall
#signal leavingCeiling


func _ready() -> void:
	inJump = false
	inHang = false
	inFall = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		inJump = false
		inHang = false
		inFall = false
		
	var directionX = Input.get_axis("legsLeft", "legsRight")
	var directionY := Input.get_axis("armsUp", "armsDown")

	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Global.can_hang and Input.is_action_just_pressed("armsUp") and !inFall:
		$"../Timers/CeilingTimer".start()
		inHang = true
		velocity.y = 0
	if inHang and Input.is_action_pressed("armsUp") and !inFall:
		if $"../Timers/CeilingTimer".get_time_left() == 0:
			$"../Timers/CeilingTimer".stop()
			inFall = true
			inHang = false
		velocity.y = 0		
	if inHang and Input.is_action_just_released("armsUp") and !inFall:
		$"../Timers/CeilingTimer".stop()
		inFall = true
		inHang = false
		
	# Handle jump.
	if Global.can_climb:
		if directionY and Input.is_action_pressed("legsJump"):
			velocity.y = 0
			position.y += directionY * CLIMB_SPEED
			$Appearance.play("climb")
		else:
			if !is_on_floor():
				$Appearance.play("climbIdle")
				
	if Input.is_action_just_pressed("legsJump") and is_on_floor() and !Global.can_climb:
		velocity.y = JUMP_VELOCITY
		inJump = true
		if directionX:
			$Appearance.play("sideJump")
		else:
			$Appearance.play("frontJump")
	
	if !inJump and !inHang:
		if directionX:
			$Appearance.play("walk")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("idle")
	elif inJump:
		if directionX:
			$Appearance.play("sideJump")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("frontJump")
	elif inHang:
		if directionX:
			$Appearance.play("walk")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("idle")
	move_and_slide()
