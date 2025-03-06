extends "res://Scripts/Gun/Base/bullet.gd"

static func create(_scene, _source_node, _direction) -> Bullet:
	var _velocity = 50
	return Bullet.create_new_bullet(_scene, _source_node, _direction, _velocity)
	