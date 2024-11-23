extends Node

signal ceilingEntered
signal ceilingExited
signal killPlayer
signal nextLevel

var isPlayerInEndZone


func _ready() -> void:
	isPlayerInEndZone = false


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
	"""
	if body.name == "LegsPlayer":
		isLegsPlayerInEndZone = true
	elif body.name == "ArmsPlayer":
		isArmsPlayerInEndZone = true
	if body.name == "LegsPlayer" or body.name == "ArmsPlayer":
		if !everyNutFound:
			$"..".dialogue("notEnoughNuts")
	
	if isLegsPlayerInEndZone and isArmsPlayerInEndZone:
		Global.can_change_assembly_state = true
		if everyNutFound:
			$"..".dialogue("canEndLevel1")
	else:
		Global.can_change_assembly_state = false"""


func _on_end_zone_body_exited(_body: Node2D) -> void:
	"""if body.name == "LegsPlayer":
		isLegsPlayerInEndZone = false
		Global.can_change_assembly_state = false
	elif body.name == "ArmsPlayer":
		isArmsPlayerInEndZone = false
		Global.can_change_assembly_state = false
	if everyNutFound:
		$"..".dialogue("leavingEndZone")"""


func endLevel() -> void:	# cette fonction est lancée par mainScript
	# gérer la fin du niveau 2
	nextLevel.emit()


func _on_death_zone_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.
