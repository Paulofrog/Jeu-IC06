extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 5.0

var isTouchingCeiling			# savoir si on est entré dans la zone de détection
var gravityDirection
signal leavingCeiling


func _ready() -> void:
	gravityDirection = 1
	Global.isArmsPlayerOnCeiling = false
	$Collision.disabled = false
	$AssembledCollision.disabled = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !Global.can_climb:
		velocity += gravityDirection * get_gravity() * delta

	if isTouchingCeiling:
		if Input.is_action_pressed("armsUp"):
			Global.isArmsPlayerOnCeiling = true
			#gravityDirection = -1
			velocity.y = 0
			$Appearance.animation = "hang"
		else:
			if Global.isArmsPlayerOnCeiling and Input.is_action_just_released("armsUp"):
				leavingCeiling.emit()
			Global.isArmsPlayerOnCeiling = false
			gravityDirection = 1
	
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
	var direction := Input.get_axis("armsLeft", "armsRight")
	if direction:
		velocity.x = direction * SPEED
		if !Global.isArmsPlayerOnCeiling:
			$Appearance.play("walk")		# Ajouter l'animation "regarder sur le côté", pour remplacer walk quand on ne peut pas marcher
		$Appearance.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and !Global.isArmsPlayerOnCeiling : $Appearance.play("idle")
		
	if !Global.are_assembled or Global.isArmsPlayerOnCeiling and !Global.can_climb:
		move_and_slide()
	else:
		self.position = $"../LegsPlayer".position + Global.ARMSPLAYER_OFFSET
		$Appearance.stop()
	
	if Global.are_assembled and Global.isArmsPlayerOnCeiling:
		$Collision.disabled = true
		$AssembledCollision.disabled = false
	else:
		$Collision.disabled = false
		$AssembledCollision.disabled = true

func _on_test_level_ceiling_entered() -> void:
	isTouchingCeiling = true


func _on_test_level_ceiling_exited() -> void:
	isTouchingCeiling = false
	$Appearance.animation = "idle"
	Global.isArmsPlayerOnCeiling = false
	gravityDirection = 1	
