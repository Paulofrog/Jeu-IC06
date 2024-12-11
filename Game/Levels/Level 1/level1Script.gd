extends Node

signal ceilingEntered
signal ceilingExited
signal killLegsPlayer
signal killArmsPlayer
signal nextLevel

var isLegsPlayerInEndZone
var isArmsPlayerInEndZone

var ecrousCount
var everyNutFound
var musicPlayer : AudioStreamPlayer

func _ready() -> void:
	isLegsPlayerInEndZone = false
	isArmsPlayerInEndZone = false
	everyNutFound = false
	ecrousCount = $Ecrous.get_child_count()
	musicPlayer = $Musique1
	musicPlayer.play()
	#$"..".assemble_players()      #(pour debug l'animation de fin)


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
	Global.targetPosition = $"..".getTargetNutPosition()
	if Global.ecrous == ecrousCount:
		everyNutFound = true
		$"..".dialogue("everyNutFound")


func _on_end_zone_body_entered(body: Node2D) -> void:
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
		Global.can_change_assembly_state = false


func _on_end_zone_body_exited(body: Node2D) -> void:
	if body.name == "LegsPlayer":
		isLegsPlayerInEndZone = false
		Global.can_change_assembly_state = false
	elif body.name == "ArmsPlayer":
		isArmsPlayerInEndZone = false
		Global.can_change_assembly_state = false
	if everyNutFound and $"..".currentLevel == 1:
		$"..".dialogue("leavingEndZone")


func endLevel() -> void:	# cette fonction est lancée par mainScript
	
	# 1) zoom de camera
	# 2) perso saute	
	# 3) porte s'ouvre et perso sort de l'écran
	$"..".playEndAnimation()
	await get_tree().create_timer(4.5).timeout
	nextLevel.emit()
	Global.can_move = true
