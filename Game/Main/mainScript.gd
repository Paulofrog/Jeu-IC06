extends Node

# Assembly
const PROXIMITY_THRESHOLD = 50.0
const PROXIMITYLABEL_OFFSET = Vector2(0, -45)

var distance
var zoom_factor

var paused = false
var pausemenu

var legsInstance
var armsInstance
var completeInstance

var currentLevel
var levelScene
var levelInstance
var legsPlayerSpawnPoint
var armsPlayerSpawnPoint

var legsScene = preload("res://Game/Players/Legs player/legsPlayerScene.tscn")
var armsScene = preload("res://Game/Players/Arms player/armsPlayerScene.tscn")
var completeplayerScene = preload("res://Game/Players/Complete player/completePlayer.tscn")
var levelTest = preload("res://Game/Levels/TestLevel/testLevelScene.tscn")
var level1 = preload("res://Game/Levels/Level 1/level1Scene.tscn")


func _ready() -> void:
	pausemenu = $CanvasLayer/PauseMenu
	currentLevel = 0
	playerSetUp()
	levelSetUp()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if !Global.are_assembled:
		UpdateCameraPosition()
		UpdateCameraZoom(delta)
		AssembleCheck()
	else:
		DisassembleCheck()
		UpdateCameraPositionAssembled()

func playerSetUp() -> void:
	armsInstance = armsScene.instantiate()
	add_child(armsInstance)
	move_child(armsInstance, 0)
	legsInstance = legsScene.instantiate()
	add_child(legsInstance)
	move_child(legsInstance, 1)
	Global.are_assembled = false

func levelSetUp() -> void:
	match currentLevel:
		0:
			levelScene = levelTest
		1:
			remove_child(levelInstance)
			levelScene = level1
	levelInstance = levelScene.instantiate()
	add_child(levelInstance)
	move_child(levelInstance, 0)
	if currentLevel >= 1:
		levelInstance.killLegsPlayer.connect(Callable(self, "kill_legs_player"))
		levelInstance.killArmsPlayer.connect(Callable(self, "kill_arms_player"))
	legsPlayerSpawnPoint = levelInstance.get_node("LegsPlayerSpawnPoint").position
	armsPlayerSpawnPoint = levelInstance.get_node("ArmsPlayerSpawnPoint").position
	SetSpawnPositions()


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
	$LegsPlayer.position = legsPlayerSpawnPoint
	$ArmsPlayer.position = armsPlayerSpawnPoint


func UpdateCameraPosition():
	$Camera.position = ($ArmsPlayer.global_position + $LegsPlayer.global_position) / 2

func UpdateCameraPositionAssembled():
	$Camera.position = $CompletePlayer.global_position
	
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


func AssembleCheck():
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
	
	if distance < PROXIMITY_THRESHOLD:
		if Input.is_action_pressed("legsAssembly") and Input.is_action_pressed("armsAssembly"):
			if $Timers/AssemblyTimer.time_left == 0:
				assemble_players()
	
func DisassembleCheck():	
	if Input.is_action_just_pressed("legsAssembly") or Input.is_action_just_pressed("armsAssembly"):
		separate_players()
		$Timers/AssemblyTimer.start()
	
func assemble_players() -> void:
	Global.are_assembled = true
	completeInstance = completeplayerScene.instantiate()
	add_child(completeInstance)
	move_child(completeInstance, 1)
	$CompletePlayer.position = $ArmsPlayer.position
	armsInstance.queue_free()
	legsInstance.queue_free()
	$MetalAudioPlayer.play()


func separate_players() -> void:
	Global.are_assembled = false
	armsInstance = armsScene.instantiate()
	add_child(armsInstance)
	move_child(armsInstance, 1)
	legsInstance = legsScene.instantiate()
	add_child(legsInstance)
	move_child(legsInstance, 2)
	$LegsPlayer.position = $CompletePlayer.position
	$ArmsPlayer.position = $CompletePlayer.position + Global.ARMSPLAYER_OFFSET
	completeInstance.queue_free()


func kill_arms_player() -> void:
	$ArmsPlayer.velocity = Vector2(0, 0)
	$ArmsPlayer.position = armsPlayerSpawnPoint


func kill_legs_player() -> void:
	$LegsPlayer.velocity = Vector2(0, 0)
	$LegsPlayer.position = legsPlayerSpawnPoint
