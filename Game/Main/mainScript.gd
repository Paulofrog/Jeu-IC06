extends Node

# Assembly
const PROXIMITY_THRESHOLD = 50.0
const PROXIMITYLABEL_OFFSET = Vector2(0, -45)

var distance
var zoom_factor

var paused = false
var pausemenu

var currentLevel
var levelScene
var levelInstance

var legs
var arms
var completeplayer


func _ready() -> void:
	pausemenu = $Camera/PauseMenu
	arms = $ArmsPlayer
	legs = $LegsPlayer
	completeplayer = $CompletePlayer
	currentLevel = 0
	levelSetUp()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	UpdateCameraPosition()
	UpdateCameraZoom(delta)
	PlayerProximityDetection()


func levelSetUp() -> void:
	match currentLevel:
		0:
			levelScene = preload("res://Game/TestLevel/testLevelScene.tscn")
		1:
			remove_child(levelInstance)
			levelScene = preload("res://Game/Level 1/level1Scene.tscn")
	levelInstance = levelScene.instantiate()
	add_child(levelInstance)
	move_child(levelInstance, 0)
	
	SetSpawnPositions()
	Global.are_assembled = false


func nextLevel() -> void:
	currentLevel += 1
	levelSetUp()


func pauseMenu() -> void:
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pausemenu.hide()
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		pausemenu.show()
	paused = !paused


func SetSpawnPositions():
	var legsPlayerSpawnPoint = levelInstance.get_node("LegsPlayerSpawnPoint").position
	var armsPlayerSpawnPoint = levelInstance.get_node("ArmsPlayerSpawnPoint").position
	$LegsPlayer.position = legsPlayerSpawnPoint
	$ArmsPlayer.position = armsPlayerSpawnPoint


func UpdateCameraPosition():
	$Camera.position = ($ArmsPlayer.global_position + $LegsPlayer.global_position) / 2


func UpdateCameraZoom(delta):
	distance = abs(($ArmsPlayer.global_position - $LegsPlayer.global_position) / 2)
	
	if roundi(distance.x*9/16) >= distance.y:
		if (0 <= distance.x and distance.x < 170):
			zoom_factor = 4
		elif (170 <= distance.x and distance.x < 350):
			zoom_factor = 2
		else:
			zoom_factor = 1
	else:
		if (0 <= distance.y and distance.y < roundi(170.*9./16.)):
			zoom_factor = 4
		elif (roundi(170.*9./16.) <= distance.y and distance.y < roundi(350.*9./16.)):
			zoom_factor = 2
		else:
			zoom_factor = 1
	if !Global.isLegsPlayerJumping:
		$Camera.zoom = $Camera.zoom.lerp(Vector2(zoom_factor, zoom_factor), ease(4 * delta, .8))


func PlayerProximityDetection():
	distance = $LegsPlayer.global_position.distance_to($ArmsPlayer.global_position)
	if (distance < PROXIMITY_THRESHOLD):
		if !Global.are_assembled:
			$ProximityLabel.position = (($ArmsPlayer.global_position + $LegsPlayer.global_position) / (2)) \
										- ($ProximityLabel.get_size() / 2) \
										+ PROXIMITYLABEL_OFFSET
			$ProximityLabel.show()
		else:
			$ProximityLabel.hide()
	else:
		$ProximityLabel.hide()
	
	if not Global.are_assembled and distance < PROXIMITY_THRESHOLD:
		if Input.is_action_pressed("legsAssembly") and Input.is_action_pressed("armsAssembly"):
			if $Timers/AssemblyTimer.time_left == 0:
				assemble_players()
	elif Global.are_assembled:
		if Input.is_action_just_pressed("legsAssembly") or Input.is_action_just_pressed("armsAssembly"):
			separate_players()
			$Timers/AssemblyTimer.start()
	
func assemble_players() -> void:
	Global.are_assembled = true
	#completeplayer.show()
	#completeplayer.position = arms.position
	#arms.hide()
	#legs.hide()
	$MetalAudioPlayer.play()


func separate_players() -> void:
	Global.are_assembled = false
	#arms.show()
	#legs.show()
	$LegsPlayer.velocity.y = 40
	$ArmsPlayer.velocity.y = 0
	#legs.position = completeplayer.position
	#arms.position = completeplayer.position + Global.ARMSPLAYER_OFFSET
	#completeplayer.hide()
