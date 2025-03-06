extends AnimatedSprite2D

var direction: Vector2
var velocity: float # Pixels per physics tick (60 per second). Values too high may result in clipping issues. 
var source_node: Node2D # Source of bullet so player doesnt shoot themselves when bullet spawns

# A bullet scene must be instantiated with an initial direction vector. Usually where the mouse points.
func _init(_source_node: Node2D, _direction: Vector2, _velocity = 50):
	source_node = _source_node
	rotation = _direction.angle()
	direction = _direction.normalized()
	velocity = _velocity
	$Light.energy = randf()
	
func _physics_process(_delta: float) -> void:
	position += direction * velocity

# Emitted when the bullet strikes anything
func _on_collider_body_entered(body: Node2D) -> void:
	if body == source_node: # Ignore shooter
		return
		
	print("Struck: ", body.name)
	# TODO: Emit particles, then
	queue_free() # Delete self after 
