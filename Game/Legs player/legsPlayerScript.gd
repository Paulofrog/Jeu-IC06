extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -540.0


func _ready() -> void:
	$Collision.disabled = false
	$AssembledCollision.disabled = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("legsJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var directionX = Input.get_axis("legsLeft", "legsRight")
	if !(Global.isArmsPlayerOnCeiling and Global.are_assembled):
		Global.directionX = directionX
	if directionX and (directionX == Global.directionX):
		velocity.x = directionX * SPEED
		$Appearance.play("walk")
		$Appearance.flip_h = directionX < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if Global.directionX:
			$Appearance.play("walk")
			$Appearance.flip_h = Global.directionX < 0
		else:
			$Appearance.play("idle")
	
	if !(Global.isArmsPlayerOnCeiling and Global.are_assembled):
		move_and_slide()
	else:
		velocity.y = 0
		self.position = $"../ArmsPlayer".position - Global.ARMSPLAYER_OFFSET
		$Appearance.stop()
	
	if Global.are_assembled:
		$Collision.disabled = true
		$AssembledCollision.disabled = false
	else:
		$Collision.disabled = false
		$AssembledCollision.disabled = true


func _on_arms_player_leaving_ceiling() -> void:
	if Global.are_assembled:
		velocity.y = -100
