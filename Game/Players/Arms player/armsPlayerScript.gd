extends CharacterBody2D


const SPEED = 200.0
const CLIMBHORIZONTALSPEED = 50.0
const CLIMB_SPEED = 5.0

var inHang
var inFall
var inClimb

func _ready() -> void:
	inHang = false
	inFall = false
	inClimb = false
	$Appearance.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		inHang = false
		inFall = false
		inClimb = false

	var directionX = Input.get_axis("armsLeft", "armsRight")
	var directionY := Input.get_axis("armsUp", "armsDown")
	
	if Global.can_move:
		if directionX:
			if inClimb:
				velocity.x = directionX * CLIMBHORIZONTALSPEED
			else:
				velocity.x = directionX * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Global.can_hang and Input.is_action_just_pressed("armsHang") and !inFall:
		$"../Timers/ArmsCeilingTimer".start()
		inHang = true
		inClimb = false
		velocity.y = 0
	if inHang and Input.is_action_pressed("armsHang") and !inFall:
		if $"../Timers/ArmsCeilingTimer".get_time_left() == 0:
			$"../Timers/ArmsCeilingTimer".stop()
			inFall = true
			inHang = false
		if !Global.can_hang:
			inFall = true
			inHang = false
		velocity.y = 0
	if inHang and Input.is_action_just_released("armsHang") and !inFall:
		$"../Timers/ArmsCeilingTimer".stop()
		inFall = true
		inHang = false
		
	if Global.can_climb and !inHang:
		inClimb = true
		if directionY:
			velocity.y = 0
			position.y += directionY * CLIMB_SPEED
			$Appearance.play("climb")
		else:
			if !is_on_floor():
				velocity.y = 0
				$Appearance.play("climbIdle")
			else : 
				inClimb = false
	if Global.can_move:
		if !inHang and !inClimb:
			if directionX:
				$Appearance.play("walk")
				$Appearance.flip_h = directionX < 0
			else:
				$Appearance.play("idle")
		elif inHang:
			if directionX:
				$Appearance.play("hangWalk")
				$Appearance.flip_h = directionX < 0
			else:
				$Appearance.play("hangIdle")
	move_and_slide()
