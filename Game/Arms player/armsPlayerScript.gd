extends CharacterBody2D

var playersAssembled
const SPEED = 150.0

func _ready() -> void:
	playersAssembled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# A FAIRE : suspension au plafond

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("armsLeft", "armsRight")
	if direction:
		velocity.x = direction * SPEED
		$Appearance.animation = "walk"
		$Appearance.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Appearance.animation = "idle"
	
	if !playersAssembled:
		move_and_slide()
