extends Node

var legsPlayerSpawnPoint


func _ready() -> void:
	legsPlayerSpawnPoint = $TestLevel/LegsPlayerSpawnPoint.position
	$LegsPlayer.position = legsPlayerSpawnPoint

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
