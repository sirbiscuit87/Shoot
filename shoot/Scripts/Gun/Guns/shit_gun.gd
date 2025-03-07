extends Gun
var LargeBullet = preload("res://Scripts/Gun/Bullets/large_bullet.gd")

# attributes for our gun will go here
func _init() -> void:
	var _firing_mode_count = 2 
	var _bullet_type = LargeBullet.new()
	var _caliber = Caliber.RIFLE
	var _fire_mode= FiringMode.AUTO
	var _ammo = 6969
	var _max_ammo = 6969
	var _fire_rate = 600 # RPM
	var _fire_delay = 0.01 # Delay between shots in seconds
	var _reload_time = 2 # In seconds
	super(
		_firing_mode_count,
		_bullet_type,
		_caliber,
		_fire_mode,
		_ammo,
		_max_ammo,
		_fire_rate,
		_fire_delay,
		_reload_time
	)
