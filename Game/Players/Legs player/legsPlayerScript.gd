extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 5.0
const JUMP_VELOCITY = -520.0

var inJump


func _ready() -> void:
	inJump = false
	Global.isLegsPlayerJumping = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		inJump = false
		Global.isLegsPlayerJumping = false
		
	var directionX = Input.get_axis("legsLeft", "legsRight")
	
	if Global.can_move:
		if directionX:
			velocity.x = directionX * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Handle jump.				
	if Input.is_action_just_pressed("legsJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		inJump = true
		Global.isLegsPlayerJumping = true
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
