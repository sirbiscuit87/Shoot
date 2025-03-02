extends Sprite2D

func _ready():
	#Todo sprite = initial sprite? stateshift handlers
	pass

func _process(_delta):
	position = get_global_mouse_position()
