extends AnimatedSprite2D
class_name Bullet

var direction: Vector2
var velocity: float # Pixels per physics tick (60 per second). Values too high may result in clipping issues. 
var source_node: Node2D # Source of bullet so player doesnt shoot themselves when bullet spawns
static var scene: PackedScene

# A bullet scene must be instantiated with an initial direction vector. Usually where the mouse points.
static func create_new_bullet(_source_node: Node2D, _direction: Vector2, _velocity = 50) -> Bullet:
	var new_bullet = scene.instantiate()
	new_bullet.source_node = _source_node
	new_bullet.rotation = _direction.angle()
	new_bullet.direction = _direction.normalized()
	new_bullet.velocity = _velocity
	var light = new_bullet.get_node("Light")
	light.energy = randf()
	return new_bullet

func _physics_process(_delta: float) -> void:
	position += direction * velocity

# Emitted when the bullet strikes anything
func _on_collider_body_entered(body: Node2D) -> void:
	if body == source_node: # Ignore shooter
		return
		
	print("Struck: ", body.name)
	# TODO: Emit particles, then
	queue_free() # Delete self after 
