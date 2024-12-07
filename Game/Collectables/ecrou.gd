extends Node2D

var targetPos
var label

signal nutJustCollected

func _ready() -> void:
	$Appearance.play("idle")
	targetPos = Vector2(0, 0)
	label = get_tree().current_scene.get_node("CanvasLayer/HUD/EcrouScore")
	label.text = str(Global.ecrous)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "LegsPlayer" or body.name == "ArmsPlayer" or body.name == "CompletePlayer"):
		Global.ecrous += 1
		nutJustCollected.emit()
		print("+1")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", targetPos, 0.5).set_ease(Tween.EASE_IN)
		tween.chain().tween_property(self, "visible", false, 0.0)
		tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.05)
		tween.tween_property(label, "text", str(Global.ecrous), 0.0)
		tween.chain().tween_property(label, "scale", Vector2(1.0, 1.0), 0.05)
		tween.chain().tween_callback(queue_free)
