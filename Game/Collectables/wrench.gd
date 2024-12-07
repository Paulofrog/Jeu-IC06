extends Node2D

signal wrenchJustCollected

func _ready() -> void:
	$Appearance.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "LegsPlayer" or body.name == "ArmsPlayer" or body.name == "CompletePlayer"):
		wrenchJustCollected.emit()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(8.0, 8.0), 1)
		tween.chain().tween_property(self, "visible", false, 0.0)
		tween.chain().tween_callback(queue_free)
