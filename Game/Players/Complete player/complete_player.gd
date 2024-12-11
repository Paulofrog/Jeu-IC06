extends CharacterBody2D


const SPEED = 300.0
const CLIMBHORIZONTALSPEED = 50.0
const CLIMB_SPEED = 5.0
const JUMP_VELOCITY = -450.0

var inJump
var inHang
var inFall
var inClimb 

var directionX = 0
var directionXarms = 0
var directionY = 0

var click_timer


func _ready() -> void:
	inJump = false
	inHang = false
	inFall = false
	inClimb = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		inJump = false
		inHang = false
		inFall = false
		inClimb = false
		
	if Global.can_move:
		directionX = Input.get_axis("legsLeft", "legsRight")
		directionXarms = Input.get_axis("armsLeft", "armsRight")
		directionY = Input.get_axis("armsUp", "armsDown")

	if directionX and !inHang:
		if inClimb:
			velocity.x = directionX * CLIMBHORIZONTALSPEED
		else:
			velocity.x = directionX * SPEED
	elif directionXarms and inHang:
		velocity.x = directionXarms * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("armsHang"):
		click_timer = get_tree().create_timer(0.5)		

	if Global.can_hang and Input.is_action_pressed("armsHang") and !inFall:
		if click_timer != null and click_timer.time_left > 0:
			$"../Timers/CeilingTimer".start()
			inHang = true
			velocity.y = 0
	if inHang and Input.is_action_pressed("armsHang") and !inFall:
		if $"../Timers/CeilingTimer".get_time_left() == 0:
			$"../Timers/CeilingTimer".stop()
			inFall = true
			inHang = false
		if !Global.can_hang:
			inFall = true
			inHang = false
		velocity.y = 0		
	if inHang and Input.is_action_just_released("armsHang") and !inFall:
		$"../Timers/CeilingTimer".stop()
		inFall = true
		inHang = false
		
	# Handle jump.
	if Global.can_climb and !inHang:
		if (Input.is_action_pressed("armsUp") and Input.is_action_pressed("legsJump")) or (Input.is_action_pressed("armsDown") and Input.is_action_pressed("legsDown")):
			velocity.y = 0
			position.y += directionY * CLIMB_SPEED
			inClimb = true
			$Appearance.play("climb")
		else:
			if !is_on_floor() and inClimb:
				velocity.y = 0
				$Appearance.play("climbIdle")
			else:
				inClimb = false
	if (inClimb or inHang) and inFall:
		inFall = false
	if Input.is_action_just_pressed("legsJump") and is_on_floor() and !inClimb:
		velocity.y = JUMP_VELOCITY
		inJump = true
		if directionX:
			$Appearance.play("sideJump")
		else:
			$Appearance.play("frontJump")
	
	if !inJump and !inHang and !inClimb:
		if directionX:
			$Appearance.play("walk")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("idle")
	elif inJump and !inHang and !inClimb:
		if directionX:
			$Appearance.play("sideJump")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("frontJump")
	elif inHang:
		if directionXarms:
			$Appearance.play("hang")
			$Appearance.flip_h = directionXarms < 0
		else:
			$Appearance.play("hangIdle")
	if is_on_floor() and !directionX:
		velocity.x = 0;
	move_and_slide()


func endAnimation() -> void:
	velocity.y = JUMP_VELOCITY
	$Appearance.play("frontJump")
	await get_tree().create_timer(1.5).timeout
	
	velocity.y = JUMP_VELOCITY
	$Appearance.play("frontJump")
	await get_tree().create_timer(1.5).timeout
	
	directionX = 1
	await get_tree().create_timer(.3).timeout
	directionX = 0
	
	# durée totale : 3.5 secondes
