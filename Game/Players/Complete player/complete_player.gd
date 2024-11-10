extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 5.0
const JUMP_VELOCITY = -400.0


var isTouchingCeiling			# savoir si on est entré dans la zone de détection
var gravityDirection
var inJump
#signal leavingCeiling


func _ready() -> void:
	gravityDirection = 1
	Global.isArmsPlayerOnCeiling = false
	$Collision.disabled = false
	inJump = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		inJump = false
		
	var directionX = Input.get_axis("legsLeft", "legsRight")
	var directionY := Input.get_axis("armsUp", "armsDown")

	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Handle jump.
	if Global.can_climb:
		if directionY and Input.is_action_pressed("legsJump"):
			velocity.y = 0
			position.y += directionY * CLIMB_SPEED
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
	
	if !inJump:
		if directionX:
			$Appearance.play("walk")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("idle")
	else:
		if directionX:
			$Appearance.play("sideJump")
			$Appearance.flip_h = directionX < 0
		else:
			$Appearance.play("frontJump")
	move_and_slide()
