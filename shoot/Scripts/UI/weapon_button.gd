extends Button
class_name WeaponButton

# Super simple class, just extends the base button class and causes the "button_up" signal to also pass a reference to the button. 
# Just made this to reduce some boilerplate.
# The buymenu uses the name of the node to determine what gun to give. 

signal weaponbutton_up(selfref)

func _ready() -> void:
	button_up.connect(on_weaponbutton_up)
	
func on_weaponbutton_up():
	weaponbutton_up.emit(self)
