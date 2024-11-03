extends CharacterBody2D


const SPEED = 300.0
const CLIMB_SPEED = 5.0
const JUMP_VELOCITY = -540.0


var isTouchingCeiling			# savoir si on est entré dans la zone de détection
var gravityDirection
#signal leavingCeiling


func _ready() -> void:
	gravityDirection = 1
	Global.isArmsPlayerOnCeiling = false
	$Collision.disabled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("legsJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
	var directionY := Input.get_axis("armsUp", "armsDown")
	if Global.can_climb:
		if directionY:
			velocity.y = 0
			position.y += directionY * CLIMB_SPEED

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("legsLeft", "legsRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
