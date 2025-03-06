extends Node2D
class_name Gun

# Base class for all future guns. Default values set to resemble an AK, for testing.
enum Caliber {SMALL, RIFLE, SHOTGUN}
enum FiringMode {SINGLE, AUTO, BURST}
var firing_mode_count: int
var bullet_type : Bullet
var caliber: Caliber
var fire_mode: FiringMode
var burst_size: int
var ammo: int
var max_ammo: int
var fire_rate: int # RPM
var fire_delay: float # Delay between shots in seconds
var reload_time: int # In seconds

var can_fire: bool = true # FireRate Locking

# Not implemented
var spread: int # Aim cone in degrees
func _init(
	_firing_mode_count: int,
	_bullet_type : Bullet,
	_caliber: Caliber,
	_fire_mode: FiringMode,
	_ammo: int,
	_max_ammo: int,
	_fire_rate: int,
	_fire_delay: float,
	_reload_time: int

) -> void:
	firing_mode_count = _firing_mode_count
	bullet_type = _bullet_type
	caliber = _caliber
	fire_mode = _fire_mode
	ammo = _ammo
	max_ammo = _max_ammo
	fire_rate = _fire_rate
	fire_delay = _fire_delay
	reload_time = _reload_time

var mouse_held: bool = false
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		can_fire = false
		await get_tree().create_timer(reload_time).timeout
		ammo = max_ammo
		emit_signal("ammo_changed")
		can_fire = true
		
	if Input.is_action_just_pressed("switch_fire_mode"):
		fire_mode = (fire_mode + 1) % firing_mode_count as FiringMode
		print(fire_mode)
		fire_mode_changed.emit()
	
	if Input.is_action_just_released("fire"):
		mouse_held = false
		
	match fire_mode:
		FiringMode.SINGLE:
			if Input.is_action_just_pressed("fire"):
				SingleFire()
		FiringMode.BURST:
			if Input.is_action_just_pressed("fire"):
				BurstFire()
		FiringMode.AUTO:
			if Input.is_action_just_pressed("fire"):
				mouse_held = true
			if mouse_held:
				AutoFire()

# Sent to HUD 
signal ammo_changed
signal fire_mode_changed

func SingleFire():
	if !can_fire:
		return
		
	if ammo > 0:
		ammo -= 1
		Shoot()
		can_fire = false
		emit_signal("ammo_changed")
		await get_tree().create_timer(fire_delay).timeout
		can_fire = true

func BurstFire():
	pass
	
func AutoFire():
	if !can_fire:
		return
	
	if ammo > 0:
		ammo -= 1
		Shoot()
		can_fire = false
		emit_signal("ammo_changed")
		await get_tree().create_timer(fire_delay).timeout
		can_fire = true

func _get_bullet() -> Bullet:
	var parent = get_parent()
	var point = get_global_mouse_position() - global_position
	var bullet = bullet_type.create(parent, point)
	bullet.global_position = global_position
	return bullet

func Shoot():
	var bullet = _get_bullet()
	get_tree().get_root().add_child(bullet) # Cant be a child of gun or it will move with the gun
	
	
