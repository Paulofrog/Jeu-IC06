extends Node2D

signal ceilingEntered
signal ceilingExited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_ceiling_area_entered() -> void:
	ceilingEntered.emit()


func _on_ceiling_area_exited() -> void:
	ceilingExited.emit()
