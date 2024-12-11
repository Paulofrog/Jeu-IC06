extends Node

signal ceilingEntered
signal ceilingExited
signal killLegsPlayer
signal killArmsPlayer
signal killPlayer
signal nextLevel
signal newSpawnPoint(spawnPoint)

var isLegsPlayerInEndZone
var isArmsPlayerInEndZone
var isPlayerInEndZone
var everyNutFound = false
var checkpointTriggered = false
var ecrousCount = 9
var musicPlayer : AudioStreamPlayer

func _ready() -> void:
	isPlayerInEndZone = false
	musicPlayer = $Musique3
	musicPlayer.play()
	$"..".dialogue("level3explanation")
	
func _process(_delta: float) -> void:
	pass


func _on_ladder_body_entered(body: Node2D) -> void:
	match body.name:
		"ArmsPlayer":
			if $"../ArmsPlayer".is_on_floor():
				Global.can_climb = true
		"CompletePlayer":
			if $"../CompletePlayer".is_on_floor():
				Global.can_climb = true
		_:
			pass


func _on_ladder_body_exited(body: Node2D) -> void:
	if body.name == "ArmsPlayer" or body.name == "CompletePlayer":
		Global.can_climb = false


func _on_ceiling_body_entered(body: Node2D) -> void:
	if body.name == "ArmsPlayer" or body.name == "CompletePlayer":
		Global.can_hang = true
		ceilingEntered.emit()


func _on_ceiling_body_exited(body: Node2D) -> void:
	if body.name == "ArmsPlayer" or body.name == "CompletePlayer":
		Global.can_hang = false
		ceilingExited.emit()


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.name == "LegsPlayer":
		killLegsPlayer.emit()
	elif body.name == "ArmsPlayer":
		killArmsPlayer.emit()
	elif body.name == "CompletePlayer":
		killPlayer.emit()


func _on_end_zone_body_entered(body: Node2D) -> void:
	if body.name == "CompletePlayer":
		if everyNutFound:
			nextLevel.emit()
		else :
			$"..".dialogue("notEnoughNutsToGoOut")
			nextLevel.emit()


func _on_ecrou_nut_just_collected() -> void:
	Global.targetPosition = $"..".getTargetNutPosition()
	if Global.ecrous == ecrousCount:
		everyNutFound = true
		$"..".dialogue("everyNutFound")


func _on_checkpoint_entered(body: Node2D) -> void:
	if body.name == "LegsPlayer" or body.name == "ArmsPlayer" or body.name == "CompletePlayer":
		if !checkpointTriggered:
			checkpointTriggered = true
			newSpawnPoint.emit($Checkpoint/ReSpawnPoint)
