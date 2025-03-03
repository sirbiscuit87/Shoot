extends CharacterBody2D

# Multiplayer
@onready
var client = get_node("/root/Main/Multiplayer")

#Early state implementation                                             
var controllable: bool = true
var in_inventory: bool = false # Player could depend on this to play inventory animations and disable certain behaviours

#Manual control variables (movement and viewdistance) 
@export var view_distance = 300
@export var movementState = 1

#Const min speed max speed
const speeds = [0.8, 1, 1.8]

# Game ref to access inventory in separate canvas layer
@onready var game_ref = $"../.."

#Child references to prevent node searching
var body
var head
var hair
var crosshair

# HARDREF 
func _ready():
	crosshair = $"../Crosshair"
	body = $Body
	head = $Head
	hair = $Head/Hair # since offset can't inherit?

#Misc


func _process(delta):
	if(controllable):
		manualMovement(delta)
		face_cursor()

func face_cursor():
	var point = (get_global_mouse_position() - global_position).angle()
	head.rotation = point + PI/2
	
	if Input.is_action_just_pressed("aim"):
		aim_offset = PI/4
	if Input.is_action_just_released("aim"):
		aim_offset = 0
		
	if aim_offset:
		head.offset.x = 1
		hair.offset.x = 1
		body.rotation = lerp_angle(body.rotation, head.rotation + aim_offset, 0.1)
	else:
		head.offset.x = 0
		hair.offset.x = 0
		body.rotation = lerp_angle(body.rotation, head.rotation, 0.1)
	
	$Legs.rotation = head.rotation

# Turn to face an object, currently unused
var aim_offset = 0
func face(object):
	var point = (object.position - position).angle()
	head.rotation = point + PI/2
	
	if Input.is_action_just_pressed("aim"):
		aim_offset = PI/4
	if Input.is_action_just_released("aim"):
		aim_offset = 0

	if aim_offset:
		head.offset.x = 1
		hair.offset.x = 1
		body.rotation = lerp_angle(body.rotation, head.rotation + aim_offset, 0.1)
	else:
		head.offset.x = 0
		hair.offset.x = 0
		body.rotation = lerp_angle(body.rotation, head.rotation, 0.1)
	
	$Legs.rotation = head.rotation

func movementStateHandler():
	if Input.is_action_just_pressed("stealth"):
		if movementState == 0: #Uncrouch
			movementState = 1
		else: #Crouch
			movementState = 0
	else:
		if Input.is_action_just_pressed("sprint"):
			movementState = 2
		if Input.is_action_just_released("sprint"):
			if movementState != 0:
				movementState = 1

func manualMovement(_delta):
	movementStateHandler()
	
	var speed = speeds[movementState]
	if Input.is_action_pressed("aim"): #Aim should flatly modify any movement state
		$Body/Rarm.show()
		$Body/Larm.show()
		speed = speed * 0.6
	else:
		$Body/Rarm.hide()
		$Body/Larm.hide()
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0: #If is moving
		if !$Legs.is_playing():
			$Legs.play()
		velocity = velocity.normalized() * speed * 100
	else:
		if $Legs.is_playing():
			$Legs.stop()
	
	move_and_slide()
	client.update_position(position)
