extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 5.0
const JUMP_VELOCITY = -540.0


func _ready() -> void:
	$Collision.disabled = false
	$AssembledCollision.disabled = true


func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor() and !Global.can_climb:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("legsJump") and is_on_floor() and !Global.can_climb:
		velocity.y = JUMP_VELOCITY
		
	var directionY := Input.get_axis("legsUp", "legsDown")
	if directionY and Global.can_climb:
		velocity.y = 0
		position.y += directionY * CLIMB_SPEED

	# Get the input direction and handle the movement/deceleration.
	var directionX = Input.get_axis("legsLeft", "legsRight")
	if directionX:
		velocity.x = directionX * SPEED
		$Appearance.animation = "walk"
		$Appearance.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Appearance.animation = "idle"
	
	if !(Global.isArmsPlayerOnCeiling and Global.are_assembled):
		move_and_slide()
	else:
		self.position = $"../ArmsPlayer".position - Global.ARMSPLAYER_OFFSET
	
	if Global.are_assembled:
		$Collision.disabled = true
		$AssembledCollision.disabled = false
	else:
		$Collision.disabled = false
		$AssembledCollision.disabled = true


func _on_arms_player_leaving_ceiling() -> void:
	if Global.are_assembled:
		velocity.y = -100
