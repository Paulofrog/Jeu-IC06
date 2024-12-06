extends Control

var mainScene
var musicPlayer : AudioStreamPlayer

func _ready() -> void:
	mainScene = preload("res://Game/Main/mainScene.tscn")
	$Arms.play("default")
	$Legs.play("default")
	musicPlayer = $MusiqueMenu
	musicPlayer.play() 


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(mainScene)


func _on_stop_pressed() -> void:
	get_tree().quit()
