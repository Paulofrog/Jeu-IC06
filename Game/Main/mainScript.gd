extends Node


func _ready() -> void:
	SetSpawnPositions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	UpdateCameraPosition()
	
	if (PlayerProximityDetected()):
		$ProximityLabel.show()
	else:
		$ProximityLabel.hide()


func SetSpawnPositions():
	var legsPlayerSpawnPoint = $TestLevel/LegsPlayerSpawnPoint.position
	var armsPlayerSpawnPoint = $TestLevel/ArmsPlayerSpawnPoint.position
	$LegsPlayer.position = legsPlayerSpawnPoint
	$ArmsPlayer.position = armsPlayerSpawnPoint


func UpdateCameraPosition():
	$Camera.position = ($ArmsPlayer.global_position + $LegsPlayer.global_position) / 2


func PlayerProximityDetected() -> bool:
	var distanceBetweenPlayers = $ArmsPlayer.global_position.distance_to($LegsPlayer.global_position)
	if distanceBetweenPlayers < 500:
		return true
	else:
		return false
