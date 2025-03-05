extends CharacterBody2D


# -- Old Code, needs review -- ##
#Manual control variables (movement and viewdistance) 
@export var view_distance = 300
var movementState = 1

# Crouch speed, normal speed, sprint speed
@export var speeds = [1.2, 1.6, 2.4]
# ----------------------------- #


#Child references to prevent node searching
var body
var head
var hair


var gun: Gun = null
func _ready():
	body = $Body
	head = $Head
	hair = $Head/Hair
	
	# -- New logic binding character to HUD --
	GiveWeapon(Gun.new())
	

func _process(delta):
	manualMovement(delta)
	face_cursor()

# ------- Movement ----- ##
var aim_offset = 0
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

## ------------------ ##


# The player script here has several signals connected to HUD. Marcus, lmk if this causes problems. I think it will. 
# Interface for giving a player a weapon. Adds Gun object to character. Signals to HUD.
signal PickedUpGun(gun: Gun)

func GiveWeapon(newgun: Gun) -> void:
	if self.gun != null:
		# TODO gun replacement logic, drop on floor?
		pass
		
	self.gun = newgun
	add_child(newgun)
	PickedUpGun.emit(newgun)
