extends Node2D
class_name Gun
const BulletType = preload("res://Scripts/Gun/Base/bullet_type.gd").BulletType
const LargeBulletScene = preload("res://Scenes/Projectiles/large_bullet.tscn")
const LargeBullet = preload("res://Scripts/Gun/Bullets/large_bullet.gd")
const SmallBulletScene = preload("res://Scenes/Projectiles/small_bullet.tscn")
const SmallBullet = preload("res://Scripts/Gun/Bullets/small_bullet.gd")

# Base class for all future guns. Default values set to resemble an AK, for testing.
enum Caliber {SMALL, RIFLE, SHOTGUN}
enum FiringMode {SINGLE, AUTO, BURST}
var firing_mode_count: int = 2 
var bullet_type : BulletType
var caliber: Caliber = Caliber.RIFLE
var fire_mode: FiringMode = FiringMode.SINGLE
var burst_size: int
var ammo: int = 30
var max_ammo: int = 30
var fire_rate: int = 600 # RPM
var fire_delay: float = 0.1 # Delay between shots in seconds
var can_fire: bool = true # FireRate Locking
var reload_time: int = 2 # In seconds

# Not implemented
var spread: int # Aim cone in degrees
func _init(_bullet_type: BulletType) -> void:
	bullet_type = _bullet_type

var mouse_held: bool = false
func _process(delta: float) -> void:
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
	var bullet: Bullet
	match bullet_type:
		BulletType.LARGE:
			bullet = LargeBullet.create(LargeBulletScene, parent, point)
		BulletType.SMALL:
			bullet = SmallBullet.create(SmallBulletScene, parent, point)
	bullet.global_position = global_position
	return bullet

func Shoot():
	var bullet = _get_bullet()
	get_tree().get_root().add_child(bullet) # Cant be a child of gun or it will move with the gun
	
	
