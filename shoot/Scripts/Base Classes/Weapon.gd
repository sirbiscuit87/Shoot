extends Node2D
class_name Gun

# Base class for all future guns. Default values set to resemble an AK, for testing.
enum CALIBERS {Small, Rifle, Shotgun}
enum FIRING_MODES {Single, Auto, Burst}
var FiringModesCount: int = 2 

var Caliber: int = CALIBERS.Rifle
var FireMode: int = FIRING_MODES.Single
var BurstSize: int
var Ammo: int = 30
var MaxAmmo: int = 30
var FireRate: int = 600 # RPM
var FireDelay: float = 0.1 # Delay between shots in seconds
var CanFire: bool = true # FireRate Locking

# Not implemented
var Spread: int # Aim cone in degrees

var MouseHeld: bool = false
func _process(delta: float) -> void:
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
		print("Shoot")
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
		print("Shoot")
		CanFire = false
		emit_signal("AmmoChanged")
		await get_tree().create_timer(FireDelay).timeout
		CanFire = true
