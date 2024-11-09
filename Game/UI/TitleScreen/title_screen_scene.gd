extends Control

var mainScene


func _ready() -> void:
	mainScene = preload("res://Game/Main/mainScene.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(mainScene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
