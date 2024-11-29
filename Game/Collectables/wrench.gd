extends Node2D

signal wrenchJustCollected

func _ready() -> void:
	$Appearance.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "LegsPlayer" or body.name == "ArmsPlayer" or body.name == "CompletePlayer"):
		wrenchJustCollected.emit()
