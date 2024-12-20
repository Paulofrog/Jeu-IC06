extends CanvasLayer

var inDialog = false
var currentIndex = 0
var dialogArray = []


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dialogPass"):
		if !inDialog:
			queue_free()
		else : 
			nextDialog()
	
	
func displayDialogs(key_):
	dialogArray = Global.dialogues[key_]
	nextDialog()


func nextDialog():
	$Text.text = dialogArray[currentIndex]
	currentIndex += 1
	inDialog = true
	Global.can_move = false
	Global.directionX = 0
	if dialogArray.size() == currentIndex:
		inDialog = false
		Global.can_move = true
