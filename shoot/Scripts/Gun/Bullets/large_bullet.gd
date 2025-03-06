extends "res://Scripts/Gun/Base/bullet.gd"

static func _static_init() -> void:
	scene = preload("res://Scenes/Projectiles/large_bullet.tscn")

static func create(_source_node, _direction) -> Bullet:
	var _velocity = 20
	return Bullet.create_new_bullet(_source_node, _direction, _velocity)
	