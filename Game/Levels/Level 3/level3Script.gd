extends Node

signal ceilingEntered
signal ceilingExited
signal killLegsPlayer
signal killArmsPlayer
signal nextLevel

var isLegsPlayerInEndZone
var isArmsPlayerInEndZone
var isPlayerInEndZone

func _ready() -> void:
	isPlayerInEndZone = false
	
func _process(_delta: float) -> void:
	pass


func _on_ladder_body_entered(body: Node2D) -> void:
	if body.name == "ArmsPlayer" or body.name == "CompletePlayer":
		Global.can_climb = true


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
