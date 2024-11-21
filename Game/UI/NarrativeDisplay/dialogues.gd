extends CanvasLayer

var inDialog = false
var currentIndex = 0
var dialogArray = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	if dialogArray.size() == currentIndex:
		inDialog = false
