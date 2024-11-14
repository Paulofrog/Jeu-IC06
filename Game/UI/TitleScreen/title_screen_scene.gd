extends Control

var mainScene
var narrativeDisplayScene
var narrativeDisplayInstance


func _ready() -> void:
	mainScene = preload("res://Game/Main/mainScene.tscn")
	narrativeDisplayScene = preload("res://Game/UI/NarrativeDisplay/narrativeDisplayScene.tscn")
	$Arms.play("default")
	$Legs.play("default")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	narrativeDisplayInstance = narrativeDisplayScene.instantiate()
	add_child(narrativeDisplayInstance)
	narrativeDisplayInstance.playButtonPressed.connect(Callable(self, "_on_play_button_pressed"))


func _on_stop_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(mainScene)
