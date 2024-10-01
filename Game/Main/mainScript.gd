extends Node

var legsPlayerSpawnPoint
var armsPlayerSpawnPoint


func _ready() -> void:
	legsPlayerSpawnPoint = $TestLevel/LegsPlayerSpawnPoint.position
	armsPlayerSpawnPoint = $TestLevel/ArmsPlayerSpawnPoint.position
	$LegsPlayer.position = legsPlayerSpawnPoint
	$ArmsPlayer.position = armsPlayerSpawnPoint

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
