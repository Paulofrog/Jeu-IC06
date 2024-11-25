extends Control

@onready var main = $"../../"

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("pause"):
			#main.pauseMenu()
	pass

func _on_resume_pressed() -> void:
	main.pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().quit()
