extends Node2D
class_name Interactable

var hovered: bool = false

func _just_hovered():
	set_process(true)
	hovered = true
	
func _just_unhovered():
	set_process(false)
	hovered = false

func _process(_delta):
	if hovered:
		if Input.is_action_just_pressed("interact"):
			_on_player_interaction()
		
func _on_player_interaction():
	print("Base interaction.")
