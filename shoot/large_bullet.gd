extends AnimatedSprite2D

var Direction: Vector2
var BulletVelocity: float = 50 # Pixels per physics tick (60 per second). Values too high may result in clipping issues. 
var SourceNode: Node2D # Source of bullet so player doesnt shoot themselves when bullet spawns

# A bullet scene must be instantiated with an initial direction vector. Usually where the mouse points.
var setupdone: bool = false
func setup(source: Node2D, initial_direction: Vector2, veloc = 50):
	SourceNode = source
	rotation = initial_direction.angle()
	Direction = initial_direction.normalized()
	BulletVelocity = veloc
	$Light.energy = randf()
	setupdone = true
	
func _physics_process(_delta: float) -> void:
	if setupdone:
		position += Direction * BulletVelocity

# Emitted when the bullet strikes anything
func _on_collider_body_entered(body: Node2D) -> void:
	if body == SourceNode: # Ignore shooter
		return
		
	print("Struck: ", body.name)
	# TODO: Emit particles, then
	queue_free() # Delete self after 
