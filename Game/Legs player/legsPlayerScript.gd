extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -540.0
var isJumping
var isJustLeavingCeiling


func _ready() -> void:
	$Collision.disabled = false
	$AssembledCollision.disabled = true
	isJumping = false
	isJustLeavingCeiling = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		if isJumping:
			isJumping = false
			# jouer animation amortissement
		elif isJustLeavingCeiling:
			isJustLeavingCeiling = false
	
	# Get the input direction.
	var directionX = Input.get_axis("legsLeft", "legsRight")
	
	# Handle jump.
	if Input.is_action_just_pressed("legsJump") and is_on_floor():
		isJumping = true
		velocity.y = JUMP_VELOCITY
		if directionX:
			$Appearance.play("sideJump")
		else:
			$Appearance.play("frontJump")

	# Handle the movement/deceleration.
	if !(Global.isArmsPlayerOnCeiling and Global.are_assembled):
		Global.directionX = directionX
	if directionX and (directionX == Global.directionX):
		velocity.x = directionX * SPEED
		if !isJumping:
			$Appearance.play("walk")
		$Appearance.flip_h = directionX < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if Global.directionX:
			$Appearance.animation = "walk"
			$Appearance.stop()
			$Appearance.frame = 16
			$Appearance.flip_h = Global.directionX < 0
		else:
			if !isJumping or isJustLeavingCeiling:
				$Appearance.play("idle")
			if Global.are_assembled and Global.isArmsPlayerOnCeiling:
				$Appearance.animation = "walk"
				$Appearance.stop()
				$Appearance.frame = 16
				$Appearance.flip_h = $"../ArmsPlayer/Appearance".flip_h 
		
	if !(Global.isArmsPlayerOnCeiling and Global.are_assembled):
		move_and_slide()
	else:
		velocity.y = 0
		$Appearance.stop()
		self.position = $"../ArmsPlayer".position - Global.LEGSPLAYER_OFFSET - Vector2(-5*Global.directionX, 0)
	
	if Global.are_assembled:
		#$Collision.disabled = true
		$AssembledCollision.disabled = false
	else:
		$Collision.disabled = false
		$AssembledCollision.disabled = true


func _on_arms_player_leaving_ceiling() -> void:
	isJustLeavingCeiling = true
	if Global.are_assembled:
		velocity.y = -10
