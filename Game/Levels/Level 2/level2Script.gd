extends Node

signal ceilingEntered
signal ceilingExited
signal killPlayer
signal nextLevel

var isPlayerInEndZone
var wrenchCollected = false
var musicPlayer : AudioStreamPlayer

func _ready() -> void:
	isPlayerInEndZone = false
	musicPlayer = $Musique2
	musicPlayer.play()
	

func _process(_delta: float) -> void:
	pass


func _on_ladder_body_entered(body: Node2D) -> void:
	if body.name == "CompletePlayer":
		Global.can_climb = true


func _on_ladder_body_exited(body: Node2D) -> void:
	if body.name == "CompletePlayer":
		Global.can_climb = false


func _on_ceiling_body_entered(body: Node2D) -> void:
	if body.name == "CompletePlayer":
		Global.can_hang = true
		ceilingEntered.emit()


func _on_ceiling_body_exited(body: Node2D) -> void:
	if body.name == "CompletePlayer":
		Global.can_hang = false
		ceilingExited.emit()


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.name == "CompletePlayer":
		killPlayer.emit()


func _on_end_zone_body_entered(_body: Node2D) -> void:
	if _body.name == "CompletePlayer":
		if wrenchCollected:
			nextLevel.emit()
		else:
			$"..".dialogue("needToCollectWrench")


func endLevel() -> void:	# cette fonction est lancée par mainScript
	# gérer la fin du niveau 2
	nextLevel.emit()


func _on_death_zone_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.


func _on_wrench_wrench_just_collected() -> void:
	wrenchCollected = true
