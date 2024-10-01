extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -540.0
var camera
var cameraSize
var cameraBounds


func _ready() -> void:
	camera = get_node("/root/MainScene/Camera")


func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("legsJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("legsLeft", "legsRight")
	if direction:
		velocity.x = direction * SPEED
		$Appearance.animation = "walk"
		$Appearance.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Appearance.animation = "idle"
	
	cameraSize = Vector2(camera.get_viewport().get_size()) - Vector2(1200,700)
	cameraBounds = Rect2(camera.position - (cameraSize / 2), cameraSize)
	
	move_and_slide()
	#position.x = clamp(position.x, cameraBounds.position.x, cameraBounds.position.x + cameraBounds.size.x)
	#position.y = clamp(position.y, cameraBounds.position.y, cameraBounds.position.y + cameraBounds.size.y)
