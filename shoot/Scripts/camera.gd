extends Camera2D


#References
@export var character: CharacterBody2D #Character to follow

#Config
@export var max_Zoom: float #closest
@export var min_Zoom: float #furthest

func _ready():
	zoom = Vector2(2, 2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if character != null:
		aimHandler(delta)
	if Input.is_action_just_pressed("zoom_in") && zoom.x <= max_Zoom:
		zoom.x += .1
		zoom.y += .1
	if Input.is_action_just_pressed("zoom_out") && zoom.x >= min_Zoom:
		zoom.x -= .1
		zoom.y -= .1

func aimHandler(delta):
	if Input.is_action_pressed("aim"):
		var lerpedVec = lerp(character.position, get_global_mouse_position(), 0.5)
		position.x = clamp(lerpedVec.x, character.position.x - character.view_distance, character.position.x + character.view_distance)
		position.y = clamp(lerpedVec.y, character.position.y - character.view_distance, character.position.y + character.view_distance)
	else:
		position = character.position
