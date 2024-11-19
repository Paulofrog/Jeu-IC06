extends Node

signal ceilingEntered
signal ceilingExited
signal killLegsPlayer
signal killArmsPlayer

var isLegsPlayerInEndZone
var isArmsPlayerInEndZone


func _ready() -> void:
	$EndZone/DetectionZone/DetectionShape.disabled = true
	isLegsPlayerInEndZone = false
	isArmsPlayerInEndZone = false


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


func _on_ecrou_nut_just_collected() -> void:
	# le but de cette fonction est de ne pas avoir cette condition dans le _process, alors qu'elle ne s'exécutera qu'une seule fois
	if Global.ecrous == $Ecrous.get_child_count():
		$EndZone/DetectionZone/DetectionShape.disabled = false


func _on_end_zone_body_entered(body: Node2D) -> void:
	if body.name == "LegsPlayer":
		isLegsPlayerInEndZone = true
	elif body.name == "ArmsPlayer":
		isArmsPlayerInEndZone = true
	
	if isLegsPlayerInEndZone and isArmsPlayerInEndZone:
		Global.can_change_assembly_state = true
	else:
		Global.can_change_assembly_state = false


func _on_end_zone_body_exited(body: Node2D) -> void:
	if body.name == "LegsPlayer":
		isLegsPlayerInEndZone = false
	elif body.name == "ArmsPlayer":
		isArmsPlayerInEndZone = false


func endLevel() -> void:	# cette fonction est lancée par mainScript
	print("Coder l'animation de fin de niveau")
	# Contrôles désactivés
	# porte qui s'ouvre et perso marche en dehors de l'écran
