extends CharacterBody2D

var playersAssembled
const SPEED = 150.0
const ARMSPLAYER_OFFSET = Vector2(-5, -30)
var isTouchingCeiling			# savoir si on est entré dans la zone de détection
var isOnCeiling					# action de se suspendre au plafond

func _ready() -> void:
	playersAssembled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if isTouchingCeiling:
		if Input.is_action_pressed("armsUp"):
			isOnCeiling = true
			$Appearance.animation = "hang"
		else:
			isOnCeiling = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("armsLeft", "armsRight")
	if direction:
		velocity.x = direction * SPEED
		if !isOnCeiling: $Appearance.animation = "walk"
		$Appearance.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !isOnCeiling : $Appearance.animation = "idle"
		
	if !playersAssembled:
		move_and_slide()
	else:
		self.position = $"../LegsPlayer".position + ARMSPLAYER_OFFSET


func _on_test_level_ceiling_entered() -> void:
	isTouchingCeiling = true
	print("entre dans le plafond")


func _on_test_level_ceiling_exited() -> void:
	isTouchingCeiling = false
	print("sort du plafond")
