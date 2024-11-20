extends CanvasLayer

@onready var text = $Text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	displayDialogs("example")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func displayDialogs(key):
	text.text = Global.dialogues[key][0]
	#for t in Global.dialogues[key]:
		#text.text = t
