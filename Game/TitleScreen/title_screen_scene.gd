extends Control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Main/mainScene.tscn")
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.