extends Node

# Assembly
const PROXIMITY_THRESHOLD = 50.0
const PROXIMITYLABEL_OFFSET = Vector2(0, -45)
var paused = false
var pausemenu
@onready var legs = $LegsPlayer
@onready var arms = $ArmsPlayer
@onready var completeplayer = $CompletePlayer


func _ready() -> void:
	pausemenu = $Camera/PauseMenu
	SetSpawnPositions()
	Global.are_assembled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	UpdateCameraPosition()
	PlayerProximityDetection()


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
	var legsPlayerSpawnPoint = $TestLevel/LegsPlayerSpawnPoint.position
	var armsPlayerSpawnPoint = $TestLevel/ArmsPlayerSpawnPoint.position
	$LegsPlayer.position = legsPlayerSpawnPoint
	$ArmsPlayer.position = armsPlayerSpawnPoint


func UpdateCameraPosition():
	$Camera.position = ($ArmsPlayer.global_position + $LegsPlayer.global_position) / 2


func PlayerProximityDetection():
	var distance = $LegsPlayer.global_position.distance_to($ArmsPlayer.global_position)
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
