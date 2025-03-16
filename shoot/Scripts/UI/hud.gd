extends Control

# All signals from the player are sent here to be managed. Appropriate calls will be propogated down.
func _on_player_picked_up_gun(gun: Gun) -> void:
	$Ammo.initialize(gun) # Ammo script connects gun signals to appropriate methods.

func _on_player_dropped_gun() -> void:
	$Ammo.disconnect_gun()
