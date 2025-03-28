extends Label

func _ready() -> void:
	hide()
	
# Ammo HUD is tied to a specific instance of a weapon. When weapon data updates, Ammo HUD should update automatically.
var SmallFireModeAtlas: CompressedTexture2D = preload("res://Art/UI/9mmFireMode.png")
var RifleFireModeAtlas: CompressedTexture2D = preload("res://Art/UI/RifleFireMode.png")

var gun: Gun
func initialize(gun: Gun):
	self.gun = gun
	
	# Signal connections
	gun.AmmoChanged.connect(AmmoChanged)
	gun.FireModeChanged.connect(FireModeChanged)
	
	AmmoChanged() # To display ammo on gun pickup
	FireModeChanged() # To display fire mode on gun pickup
	
	show()

# Disconnects all current signals from the gun
func disconnect_gun():
	self.gun.AmmoChanged.disconnect(AmmoChanged)
	self.gun.FireModeChanged.disconnect(FireModeChanged)
	
	hide()
	
	self.gun = null
	

func AmmoChanged():
	self.text = str(gun.Ammo) + "/" + str(gun.MaxAmmo)

func FireModeChanged():
	# Must keep these consistent for all atlases for all calibers!
	# Single fire - 0 0 64 64
	# Auto fire - 0 64 64 64
	# Burst fire - 64 0 64 64
	
	
	var region
	match gun.FireMode:
		0: # Single fire
			region = Rect2(0,0,64,64)
		1: # Auto fire
			region = Rect2(0,64,64,64)
		2: # Burst fire
			region = Rect2(64,0,64,64)
	
	match gun.Caliber:
		0: # Small caliber
			var picRef = $FireModeImage
			picRef.texture = AtlasTexture.new()
			picRef.texture.atlas = SmallFireModeAtlas
			picRef.texture.region = region
		1: # Rifle caliber
			var picRef = $FireModeImage
			picRef.texture = AtlasTexture.new()
			picRef.texture.atlas = RifleFireModeAtlas
			picRef.texture.region = region
		2: # Shotgun Caliber
			pass
	
