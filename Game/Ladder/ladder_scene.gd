extends Area2D

@onready var main = $"../../"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "LegsPlayer":
			Global.can_climb = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "LegsPlayer":
			Global.can_climb = false
