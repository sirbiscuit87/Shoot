extends "res://Scripts/Gun/Base/gun.gd"
var LargeBullet = preload("res://Scripts/Gun/Bullets/large_bullet.gd")

# attributes for our gun will go here
func _init() -> void:
    super(LargeBullet.new())