extends CharacterBody2D


const SPEED = 200.0
const CLIMB_SPEED = 5.0

var isTouchingCeiling			# savoir si on est entré dans la zone de détection
var adjustPosition
signal leavingCeiling


func _ready() -> void:
	Global.isArmsPlayerOnCeiling = false
	$Collision.disabled = false
	$AssembledCollision.disabled = true
	adjustPosition = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !Global.can_climb:
		velocity += get_gravity() * delta
	
	if isTouchingCeiling:
		if Input.is_action_pressed("armsUp") and $"../Timers/CeilingTimer".time_left == 0:
			Global.isArmsPlayerOnCeiling = true
			if adjustPosition:
				position.y -= 6
				adjustPosition = false
			velocity.y = 0
			if !Global.directionX:
				$Appearance.play("hangIdle")
		else:
			if Global.isArmsPlayerOnCeiling and Input.is_action_just_released("armsUp"):
				leavingCeiling.emit()
				adjustPosition = true
			Global.isArmsPlayerOnCeiling = false
	
	var directionY := Input.get_axis("armsUp", "armsDown")
	if Global.can_climb:
		if directionY:
			velocity.y = 0
			position.y += directionY * CLIMB_SPEED
			$Appearance.play("climb")
		else:
			if !is_on_floor():
				$Appearance.play("climbIdle")

	# Get the input direction and handle the movement/deceleration.
	var directionX := Input.get_axis("armsLeft", "armsRight")
	if !Global.are_assembled or Global.isArmsPlayerOnCeiling and !Global.can_climb:
		Global.directionX = directionX
	if directionX and (directionX == Global.directionX):
		velocity.x = directionX * SPEED
		if !Global.are_assembled:
			if !Global.isArmsPlayerOnCeiling:
				$Appearance.play("walk")		# Ajouter l'animation "regarder sur le côté", pour remplacer walk quand on ne peut pas marcher
			else:
				$Appearance.play("hangWalk")
		$Appearance.flip_h = directionX < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if Global.directionX:
			$Appearance.animation = "walk"
			$Appearance.stop()
			$Appearance.frame = 25
			$Appearance.flip_h = Global.directionX < 0
		else:
			if !Global.isArmsPlayerOnCeiling and !Global.isLegsPlayerJumping:
				$Appearance.play("idle")

	if !Global.are_assembled or Global.isArmsPlayerOnCeiling and !Global.can_climb:
		move_and_slide()
	else:
		self.position = $"../LegsPlayer".position + Global.ARMSPLAYER_OFFSET
	
	if Global.are_assembled and Global.isArmsPlayerOnCeiling:
		#$Collision.disabled = true
		$AssembledCollision.disabled = false
	else:
		$Collision.disabled = false
		$AssembledCollision.disabled = true

func _on_test_level_ceiling_entered() -> void:
	isTouchingCeiling = true


func _on_test_level_ceiling_exited() -> void:
	isTouchingCeiling = false
	$Appearance.play("idle")
	Global.isArmsPlayerOnCeiling = false
	$"../Timers/CeilingTimer".start()
