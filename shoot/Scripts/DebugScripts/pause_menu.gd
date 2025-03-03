extends Control

# Temporary for debug
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	hide()

var paused: bool = false
func _process(delta: float) -> void:
	# For debugging and exiting since cursor is locked
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		if(paused):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			show()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			hide()
