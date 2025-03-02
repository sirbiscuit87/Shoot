extends Sprite2D

func _ready() -> void:
	pass
	


@export var SPEED: float = 10
func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("MoveDown"):
		self.position += Vector2.DOWN * SPEED
	if Input.is_action_pressed("MoveUp"):
		self.position += Vector2.UP * SPEED
	if Input.is_action_pressed("MoveLeft"):
		self.position += Vector2.LEFT * SPEED
	if Input.is_action_pressed("MoveRight"):
		self.position += Vector2.RIGHT * SPEED
	
