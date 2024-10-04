extends Node

# Assembly
const PROXIMITY_THRESHOLD = 120.0
const ARMSPLAYER_OFFSET = Vector2(0, -120)
const PROXIMITYLABEL_OFFSET = Vector2(0, -85)
var are_assembled
var paused = false
@onready var pausemenu = $Camera/PauseMenu

func _ready() -> void:
	SetSpawnPositions()
	are_assembled = false


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
		if !are_assembled:
			$ProximityLabel.position = (($ArmsPlayer.global_position + $LegsPlayer.global_position) / (2)) \
										- ($ProximityLabel.get_size() / 2) \
										+ PROXIMITYLABEL_OFFSET
			$ProximityLabel.show()
	else:
		$ProximityLabel.hide()
	
	if not are_assembled and distance < PROXIMITY_THRESHOLD:
		if Input.is_action_pressed("legsAssembly") and Input.is_action_pressed("armsAssembly"):
			assemble_players()
	elif are_assembled:
		if Input.is_action_just_pressed("legsAssembly") != Input.is_action_just_pressed("armsAssembly"):
			separate_players()
		# $ArmsPlayer.position = $LegsPlayer.position + ARMSPLAYER_OFFSET
		# Ca bug énormément et en plus les collisions ne sont plus prises en compte.

func assemble_players() -> void:
	are_assembled = true
	$ArmsPlayer.playersAssembled = true
	$ArmsPlayer.position = $LegsPlayer.position + ARMSPLAYER_OFFSET


func separate_players() -> void:
	are_assembled = false
	$ArmsPlayer.playersAssembled = false
