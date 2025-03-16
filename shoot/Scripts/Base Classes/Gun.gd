extends Node2D
class_name Gun

# Base class for all future guns. Default values set to resemble an AK, for testing.
enum CALIBERS {Small, Rifle, Shotgun}
enum FIRING_MODES {Single, Auto, Burst}
var FiringModesCount: int = 2 

@export_enum("Small", "Rifle", "Shotgun") var Caliber: int = CALIBERS.Rifle
@export_enum("Single", "Auto", "Burst") var FireMode: int = FIRING_MODES.Single
var BurstSize: int # TODO: implement burst properly
var Ammo: int = 30
@export var MaxAmmo: int = 30
@export var FireRate: float = 600 # RPM
var FireDelay: float = 0.1 # Delay between shots in seconds
var CanFire: bool = true # FireRate Locking
@export var ReloadTime: float = 2 # In seconds

# Not implemented
var Spread: int # Aim cone in degrees

var projectile_scene
func _ready() -> void:
	# Setup for a gun involves loading of proper assets
	match Caliber:
		CALIBERS.Small:
			projectile_scene = load("res://Scenes/Projectiles/small_bullet.tscn")
		CALIBERS.Rifle:
			projectile_scene = load("res://Scenes/Projectiles/large_bullet.tscn")
		CALIBERS.Shotgun:
			# TODO
			pass
			
	# RPM conversion
	FireDelay = 1 / (FireRate / 60)
	
	# Set ammo to full by default
	Ammo = MaxAmmo

var MouseHeld: bool = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		CanFire = false
		await get_tree().create_timer(ReloadTime).timeout
		Ammo = MaxAmmo
		emit_signal("AmmoChanged")
		CanFire = true
		
	if Input.is_action_just_pressed("switch_fire_mode"):
		FireMode = (FireMode + 1) % FiringModesCount
		print(FireMode)
		FireModeChanged.emit()
	
	if Input.is_action_just_released("fire"):
		MouseHeld = false
		
	match FireMode:
		FIRING_MODES.Single:
			if Input.is_action_just_pressed("fire"):
				SingleFire()
		FIRING_MODES.Burst:
			if Input.is_action_just_pressed("fire"):
				BurstFire()
		FIRING_MODES.Auto:
			if Input.is_action_just_pressed("fire"):
				MouseHeld = true
			if MouseHeld:
				AutoFire()

# Sent to HUD 
signal AmmoChanged
signal FireModeChanged

func SingleFire():
	if !CanFire:
		return
		
	if Ammo > 0:
		Ammo -= 1
		Shoot()
		CanFire = false
		emit_signal("AmmoChanged")
		await get_tree().create_timer(FireDelay).timeout
		CanFire = true

func BurstFire():
	pass
	
func AutoFire():
	if !CanFire:
		return
	
	if Ammo > 0:
		Ammo -= 1
		Shoot()
		CanFire = false
		emit_signal("AmmoChanged")
		await get_tree().create_timer(FireDelay).timeout
		CanFire = true

# Overridden by subclasses. IE shotgun spread, sniper w/ tracers, whatever. 
func Shoot():
	var proj = projectile_scene.instantiate()
	proj.global_position = global_position
	var point = get_global_mouse_position() - global_position
	proj.setup(get_parent(), point) # Player (parent) is passed as the source of the bullet (so shooter wont hit itself)
	get_tree().get_root().add_child(proj) # Cant be a child of gun or it will move with the gun
	
	
