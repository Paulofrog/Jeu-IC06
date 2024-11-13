extends Control

var mainScene


func _ready() -> void:
	mainScene = preload("res://Game/Main/mainScene.tscn")
	$Arms.play("default")
	$Legs.play("default")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(mainScene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(mainScene)


func _on_stop_pressed() -> void:
	get_tree().quit()
