extends Node

# Assembly
const PROXIMITY_THRESHOLD = 50.0
const PROXIMITYLABEL_OFFSET = Vector2(0, -45)

var distance
var zoom_factor
var screenWitdh
var levelWitdh

var paused = false
var pausemenu

var legsInstance
var armsInstance
var completeInstance
var dialogueInstance

var currentLevel
var levelScene
var levelInstance
var legsPlayerSpawnPoint
var armsPlayerSpawnPoint
var completePlayerSpawnPoint

var legsScene = preload("res://Game/Players/Legs player/legsPlayerScene.tscn")
var armsScene = preload("res://Game/Players/Arms player/armsPlayerScene.tscn")
var completeplayerScene = preload("res://Game/Players/Complete player/completePlayer.tscn")
var levelTest = preload("res://Game/Levels/TestLevel/testLevelScene.tscn")
var level1 = preload("res://Game/Levels/Level 1/level1Scene.tscn")
var level2 = preload("res://Game/Levels/Level 2/level2Scene.tscn")
var level3 = preload("res://Game/Levels/Level 3/level3Scene.tscn")
var dialogueScene = preload("res://Game/UI/NarrativeDisplay/Dialogues.tscn")


func _ready() -> void:
	pausemenu = $CanvasLayer/PauseMenu
	$ProximityLabel.hide()
	Global.ecrous = 0
	currentLevel = 1
	levelSetUp()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if !Global.are_assembled:
		if currentLevel == 0:
			UpdateCameraZoom(delta)
		AssembleCheck()
	else:
		DisassembleCheck()
	UpdateCameraPosition()
	
	if Input.is_action_just_pressed("skipLevel"):
		if currentLevel == 1:
			Global.are_assembled = true
			completeInstance = completeplayerScene.instantiate()
			add_child(completeInstance)
			move_child(completeInstance, 1)
			$CompletePlayer.position = $ArmsPlayer.position
			armsInstance.queue_free()
			legsInstance.queue_free()
		nextLevel()


func twoPlayerSetUp() -> void:
	armsInstance = armsScene.instantiate()
	add_child(armsInstance)
	move_child(armsInstance, 0)
	legsInstance = legsScene.instantiate()
	add_child(legsInstance)
	move_child(legsInstance, 1)
	Global.are_assembled = false


func completePlayerSetUp() -> void:
	if !(is_instance_valid(completeInstance)):
		completeInstance = completeplayerScene.instantiate()
		add_child(completeInstance)
		move_child(completeInstance, 0)
		Global.are_assembled = true


func levelSetUp() -> void:
	Global.ecrous = 0
	Global.can_move = true
	match currentLevel:
		0:
			levelScene = levelTest
			twoPlayerSetUp()
			Global.can_change_assembly_state = true
			levelInstance = levelScene.instantiate()
			add_child(levelInstance)
			move_child(levelInstance, 0)
			legsPlayerSpawnPoint = levelInstance.get_node("LegsPlayerSpawnPoint").position
			armsPlayerSpawnPoint = levelInstance.get_node("ArmsPlayerSpawnPoint").position
			SetTwoPlayersSpawnPositions()
			resetCamera()
		1:
			levelScene = level1
			twoPlayerSetUp()
			showEcrou()
			Global.can_change_assembly_state = false
			levelInstance = levelScene.instantiate()
			add_child(levelInstance)
			move_child(levelInstance, 0)
			levelInstance.nextLevel.connect(Callable(self, "nextLevel"))
			levelInstance.killLegsPlayer.connect(Callable(self, "kill_legs_player"))
			levelInstance.killArmsPlayer.connect(Callable(self, "kill_arms_player"))
			legsPlayerSpawnPoint = levelInstance.get_node("LegsPlayerSpawnPoint").position
			armsPlayerSpawnPoint = levelInstance.get_node("ArmsPlayerSpawnPoint").position
			SetTwoPlayersSpawnPositions()
			dialogue("expositionSequence")
			resetCamera()
		2:
			levelScene = level2
			completePlayerSetUp()
			hideEcrou()
			Global.can_change_assembly_state = false
			levelInstance = levelScene.instantiate()
			add_child(levelInstance)
			move_child(levelInstance, 0)
			levelInstance.killPlayer.connect(Callable(self, "kill_player"))
			levelInstance.nextLevel.connect(Callable(self, "nextLevel"))
			completePlayerSpawnPoint = levelInstance.get_node("CompletePlayerSpawnPoint").position
			SetCompletePlayerSpawnPosition()
			resetCamera()
		3:
			levelScene = level3
			completePlayerSetUp()
			showEcrou()
			Global.can_change_assembly_state = true
			levelInstance = levelScene.instantiate()
			call_deferred("add_child", levelInstance)
			call_deferred("move_child", levelInstance, 0)
			levelInstance.killPlayer.connect(Callable(self, "kill_player"))
			levelInstance.killLegsPlayer.connect(Callable(self, "kill_legs_player"))
			levelInstance.killArmsPlayer.connect(Callable(self, "kill_arms_player"))
			levelInstance.nextLevel.connect(Callable(self, "nextLevel"))
			levelInstance.newSpawnPoint.connect(Callable(self, "newSpawnPoint"))
			completePlayerSpawnPoint = levelInstance.get_node("CompletePlayerSpawnPoint").position
			legsPlayerSpawnPoint = levelInstance.get_node("LegsPlayerSpawnPoint").position
			armsPlayerSpawnPoint = levelInstance.get_node("ArmsPlayerSpawnPoint").position
			SetCompletePlayerSpawnPosition()
			resetCamera()
		_:
			get_tree().change_scene_to_file("res://Game/UI/TitleScreen/titleScreenScene.tscn")


func nextLevel() -> void:
	currentLevel += 1
	call_deferred("remove_child", levelInstance)
	levelSetUp()


func hideEcrou() -> void:
	$CanvasLayer/HUD.hide()


func showEcrou() -> void:
	$CanvasLayer/HUD.show()


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


func SetTwoPlayersSpawnPositions():
	$LegsPlayer.position = legsPlayerSpawnPoint
	$ArmsPlayer.position = armsPlayerSpawnPoint


func SetCompletePlayerSpawnPosition():
	$CompletePlayer.position = completePlayerSpawnPoint

func resetCamera() -> void:
	levelWitdh = levelInstance.get_node("Background").scale.x * levelInstance.get_node("Background").texture.get_width()
	screenWitdh = get_viewport().get_visible_rect().size.x
	var ratio = screenWitdh / levelWitdh
	$Camera.zoom = Vector2(ratio, ratio)
	$Camera.position.x = levelWitdh/2.
	match currentLevel:
		2:
			$Camera.position.y = 1400
		3:
			$Camera.position.y = 817
		_:
			$Camera.position.y = levelWitdh/2.*0.521


func UpdateCameraPosition():
	match currentLevel:
		1:
			pass
		2:
			if $CompletePlayer.global_position.y <= 1400:
				$Camera.position.y = $CompletePlayer.global_position.y
			else : 
				$Camera.position.y = 1400
		3:
			if Global.are_assembled:
				if has_node("CompletePlayer"):
					if $CompletePlayer.global_position.y <= 817:
						$Camera.position.y = $CompletePlayer.global_position.y
					else:
						$Camera.position.y = 817
			else:
				if $ArmsPlayer.global_position.y >= $LegsPlayer.global_position.y:
					if $ArmsPlayer.global_position.y <= 817:
						$Camera.position.y = $ArmsPlayer.global_position.y
					else:
						$Camera.position.y = 817
				else:
					if $LegsPlayer.global_position.y <= 817:
						$Camera.position.y = $LegsPlayer.global_position.y
					else:
						$Camera.position.y = 817
		_:
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


func AssembleCheck():
	if Global.can_change_assembly_state:
		distance = $LegsPlayer.global_position.distance_to($ArmsPlayer.global_position)
		if (distance < PROXIMITY_THRESHOLD):
			if !Global.are_assembled:
				#$ProximityLabel.position = (($ArmsPlayer.global_position + $LegsPlayer.global_position) / (2)) \
				#							- ($ProximityLabel.get_size() / 2) \
				#							+ PROXIMITYLABEL_OFFSET
				#$ProximityLabel.show()
				pass
			else:
				#$ProximityLabel.hide()
				pass
		else:
			#$ProximityLabel.hide()
			pass
		
		if distance < PROXIMITY_THRESHOLD:
			if Input.is_action_pressed("legsAssembly") and Input.is_action_pressed("armsAssembly"):
				if $Timers/AssemblyTimer.time_left == 0:
					assemble_players()


func DisassembleCheck():
	if Global.can_change_assembly_state:
		if Input.is_action_just_pressed("legsAssembly") or Input.is_action_just_pressed("armsAssembly"):
			separate_players()
			$Timers/AssemblyTimer.start()


func assemble_players() -> void:
	Global.are_assembled = true
	completeInstance = completeplayerScene.instantiate()
	await get_tree().process_frame
	add_child(completeInstance)
	move_child(completeInstance, 1)
	$CompletePlayer.position = $ArmsPlayer.position
	armsInstance.queue_free()
	legsInstance.queue_free()
	$MetalAudioPlayer.play()
	if currentLevel == 1:
		await get_tree().create_timer(.1).timeout
		dialogue("endingLevel")
		while dialogueInstance != null:
				await get_tree().process_frame
		await get_tree().create_timer(.1).timeout
		levelInstance.endLevel()


func playEndAnimation() -> void:
	$CompletePlayer.endAnimation()


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

func kill_player() -> void:
	$CompletePlayer.velocity = Vector2(0, 0)
	$CompletePlayer.position = completePlayerSpawnPoint

func newSpawnPoint(spawnPoint) -> void:
	legsPlayerSpawnPoint = spawnPoint.position
	armsPlayerSpawnPoint = spawnPoint.position
	completePlayerSpawnPoint = spawnPoint.position

func dialogue(key):
	if dialogueInstance != null:
		dialogueInstance.queue_free()
	dialogueInstance = dialogueScene.instantiate()
	dialogueInstance.displayDialogs(key)
	$CanvasLayer.call_deferred("add_child", dialogueInstance)
	#$CanvasLayer.call_deferred("move_child", dialogueInstance, 0)


func getTargetNutPosition() -> Vector2:
	#print(Vector2($Camera.position.x - levelWitdh*$Camera.scale.x/2. + 10  , $Camera.position.y - levelWitdh*9./16.*$Camera.scale.y/2. + 60))
	return Vector2($Camera.position.x - levelWitdh*$Camera.scale.x/2. + 10  , $Camera.position.y - levelWitdh*9./16.*$Camera.scale.y/2. + 60)
