extends Control

# Get reference of player, see if they can access buy menu
func _ready():
	hide()
	
	# Connecting all button signals. See weaponbutton script for why. 
	for weaponbutton in $BackgroundPanel/WeaponButtons.get_children():
		weaponbutton.weaponbutton_up.connect(purchase_clicked)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_shop"):
		if visible:
			close()
		else:
			open()

func open():
	if(true): # becomes if (player can open buy menu)
		show()

func close():
	hide()

# All gun buttons signal to here and pass themselves as a reference
func purchase_clicked(button_ref):
	# TODO: money, purchase conditions logic
	match button_ref.name:
		"AK":
			var AKscene = load("res://Scenes/Guns/AK.tscn")
			var AK = AKscene.instantiate()
			
			# Absolutely disgusting VVVV. Marcus fix!
			$"../../../Player".GiveWeapon(AK)
			
			print("AK")
		"Thompson":
			var Thompsonscene = load("res://Scenes/Guns/Thompson.tscn")
			var Thompson = Thompsonscene.instantiate()
			
			# Absolutely disgusting VVVV. Marcus fix!
			$"../../../Player".GiveWeapon(Thompson)
			
			print("Thompson")
		"Pumpy":
			print("Pumpy")
